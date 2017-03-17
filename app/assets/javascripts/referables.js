var selectedReferences = {};
var currentModalOptions = {};

// TODO non-references multi-click

/*
 * Sets the modal options
 * @param {String} modalKey: Specifies the class name of the references being shown in the modal.
 * @param {String} modalTitle: What will be shown in the modal as part of the title.
 * @param {Bool}   multipleSelection: Whether the user should be able to select more than 1 element.
 * @param {Object} target: The jQuery selector of the section where the selected reference(s) should
 *     be displayed.
 *       If `multipleSelection` is false, the corresponding element should have two
 *     fields: A `text-field.form-control` where the name is displayed, and a
 *     `hidden-input.form-control-hidden` where the ID will be stored.
 *       If `multipleSelection` is true, it will add the fields as needed.
 *
 */
function setCurrentModalOptions(modalKey, modalTitle, multipleSelection, target) {
    if (modalKey === undefined &&
        modalTitle === undefined &&
        multipleSelection === undefined &&
        target == undefined) {
        currentModalOptions = {};
        return;
    }

    if (target === undefined) {
        target = $('#references-container');
    }

    currentModalOptions = {
        modalKey: modalKey.trim(),
        modalTitle: modalTitle.trim(),
        multiple: multipleSelection,
        target: target
    }
}

function setSelectedReferences(referencesHash, target) {
    selectedReferences = referencesHash == null ? {} : referencesHash;

    for (var key in selectedReferences) {
        for (var i = 0; i < selectedReferences[key].length; i++) {
            addReferenceToTarget(key, selectedReferences[key][i], null, target);
        }
    }
}

function getModalId(className) {
    return className == 'Position' ? '#positions-modal' : '#table-modal';
}

function renderReferencesModal(resetTabs, extra) {
    addedParam = extra === undefined || extra == '' ? '/noextra' : ('/' + extra);

    $.ajax({url: '/referables/' + currentModalOptions['modalKey'] + addedParam});

    if (getModalId(currentModalOptions['modalKey']) == '#table-modal' && resetTabs) {
        $('#references-tabs').find('a[data-target="#table"]').tab('show');
    }
}

function showReferencesModal() {
    var selector = getModalId(currentModalOptions['modalKey']);

    $(selector + '-title').html('Seleccionar ' + currentModalOptions['modalTitle']);
    $(selector).modal();
}

function renderAndShowReferencesModal(extra) {
    renderReferencesModal(false, extra);
    showReferencesModal();
}

function checkModalOptions() {
    return !(Object.keys(currentModalOptions).length === 0)
}

function processReferenceRowClick(selector, objectId, name) {
    if (checkModalOptions()) {
        var classKey = currentModalOptions['modalKey'];
    } else {
        return;
    }

    if (!currentModalOptions['multiple']) {
        var target = currentModalOptions['target'];
        target.find('.form-control').val(name);
        target.find('.form-control-hidden').val(objectId);
        return true;
    }

    var isSelected = isSelectedReference(classKey, objectId);

    if (isSelected) {
        removeReference(classKey, objectId);
        removeReferenceFromTarget(objectId);
    } else {
        addReference(classKey, objectId);
        addReferenceToTarget(classKey, objectId, name);
    }

    styleSelection(selector, !isSelected);
}

function processNewReferenceCreated(formResponse) {
    if (checkModalOptions()) {
        var classKey = currentModalOptions['modalKey'];
    } else {
        return;
    }

    var objectId = formResponse['object_id'];
    var objectName = formResponse['object_name'];

    if (!currentModalOptions['multiple']) {
        var target = currentModalOptions['target'];
        target.find('.form-control').val(objectName);
        target.find('.form-control-hidden').val(objectId);
        return true;
    }

    addReference(classKey, objectId);
    renderReferencesModal(true);

    addReferenceToTarget(classKey, objectId, objectName);
}

function isSelectedReference(classKey, objectId) {
    return (classKey in selectedReferences) &&
        (selectedReferences[classKey].includes(objectId));
}

function addReference(classKey, objectId) {
    if (!(classKey in selectedReferences)) {
        selectedReferences[classKey] = [];
    }

    if (!(selectedReferences[classKey].includes(objectId))) {
        selectedReferences[classKey].push(objectId);
    }
}

function removeReference(classKey, objectId) {
    if (isSelectedReference(classKey, objectId)) {
        var index = selectedReferences[classKey].indexOf(objectId);
        if (index !== -1) {
            selectedReferences[classKey].splice(index, 1);
        }
    }
}

function addReferenceToTarget(classKey, id, name, target) {
    if (target === undefined) {
        target = currentModalOptions['target'];
    }
    target.append(
        '<div id="reference-' + id + '" style="margin: 0 50px">\n' +

        '<input class="form-control-hidden" type="hidden" ' +
        'name="references[' + classKey + '][]" id="references_' + classKey + '" ' +
        'value="' + id + '">\n' +

        '<input class="form-control" readonly="readonly" type="text" ' +
        'name="references-extra[' + classKey + '][]" id="references-extra_' + classKey + '" ' +
        'value="' + currentModalOptions['modalTitle'] + ': ' + name + '">\n' +

        '</div>');
}

function removeReferenceFromTarget(id) {
    var reference = currentModalOptions['target'].find('#reference-' + id);
    if (reference.length > 0) {
        reference.remove();
    }
}

function styleSelectedRows(rows) {
    if (!currentModalOptions['multiple']) {
        return;
    }

    rows.each(function () {
        var row = $(this);
        styleSelection(row,
            isSelectedReference(currentModalOptions['modalKey'], row.attr('data-id')));
    });
}

function styleSelection(selector, selected) {
    selector.css('background-color', selected? selectedReferenceRowBgColor() : '#fff');
}

function selectedReferenceRowBgColor() {
    return '#88a37f';
}