const SELECTED_BACKGROUND_COLOR = '#88a37f';
const UNSELECTED_BACKGROUND_COLOR = '#ffffff';

var selectedReferences = {};
var otherObjectLists = {};

/**
 * Valid options:
 *   klass             -> The Class of the objects being selected.
 *   modalTitle        -> The modal's visible title
 *   multiple          -> Whether the modal should allow for multiple items to be selected.
 *   target            -> The jQuery selector where the items will be added to.
 *    ~ default : $('references-container')
 *   listKey           -> Which list from otherObjectLists the items will be added to.
 *    ~ default : Items are added to selectedReferences.
 *   elementGenerator -> The function that generates the HTML elements where the selected items
 *                        are shown.
 *    ~ default : defaultElementGenerator
 *   elementRemover -> The function that removes the HTML elements from where the selected items
 *                        are shown.
 *    ~ default : defaultElementRemover
 */
var currentOptions = {};


/**
 * Sets the modal options
 * @param klass Specifies the class name of the references being shown in the modal.
 * @param modalTitle What will be shown in the modal as part of the title.
 * @param isMultiple Whether the user should be able to select more than 1 element.
 *       If `multipleSelection` is false, the corresponding element should have two
 *     fields: A `text-field.form-control` where the name is displayed, and a
 *     `hidden-input.form-control-hidden` where the ID will be stored.
 *       If `multipleSelection` is true, it will add the fields as needed.
 * @param targetSelector: The jQuery selector of the section where the selected
 *   object(s) should be displayed. If it's actual references, either left undefined or
 *   set to default (`$('references-container')`)
 * @param listKey The key under which the selected object(s) will be stored. If it's
 *   actual references, it must be left undefined or set to false.
 *
 */
function setOptions(klass, modalTitle, isMultiple, listKey, targetSelector) {
    // If either klass or modalTitle aren't there, there's no arguments,
    // thus it's assumed that options are being reset.
    if (klass === undefined || modalTitle === undefined) {
        currentOptions = {};
        return;
    }

    var multiple = isMultiple === undefined ? true : isMultiple;

    currentOptions = {
        klass: klass.trim(),
        modalTitle: modalTitle.trim(),
        multiple: multiple,
        elementGenerator: multiple ? defaultReferenceElementGenerator : defaultSingleElementGenerator,
        elementRemover: defaultElementRemover
    };

    if (targetSelector === undefined || listKey === undefined) {
        if (!multiple) {
            // Can't have references if it's not multiple selection!
            currentOptions = {};
            return;
        }
        // Assume it's references
        currentOptions['target'] = $('#references-container');
        currentOptions['listKey'] = false;
    } else {
        currentOptions['target'] = targetSelector;
        currentOptions['listKey'] = listKey;
    }
}

/**
 * Sets a new generator function to be used when visually adding the references
 * to the given target.
 * This generator is reset every time the options are reset or reloaded.
 *
 * The generators should have the params `klass`, `id` and `name`.
 *
 * @param generator The function that generates the HTML elements that will be appended
 *   to the target.
 *
 * @see defaultElementGenerator
 */
function setElementGenerator(generator) {
    currentOptions['elementGenerator'] = generator;
}

/**
 * Sets a remover function to be used when visually removing the references
 * from the given target.
 * This remover is reset every time the options are reset or reloaded.
 *
 * Removers should have the parameters ``
 *
 * @param remover The function that removes the HTML element that visually represents
 * an object.
 *
 * @see defaultElementRemover
 */
function setElementRemover(remover) {
    currentOptions['elementRemover'] = remover;
}

/**
 * Check if the options object is correctly set or not.
 */
function checkOptions() {
    return !(Object.keys(currentOptions).length === 0)
}

/**
 * Loads a set of reference objects (overwriting the current list) and makes them
 * visible for the user.
 *
 * @param referencesHash The list of objects. If null, the set will be set to `{}`.
 * @param target The jQuery selector for where the objects should be displayed, or `null` if
 *   the rendering will be done separately.
 * @param generator The generator to be used.
 */
function setSelectedReferences(referencesHash, target, generator) {
    // Filter out undefined or null hashes.
    if (referencesHash === undefined || referencesHash === null) {
        selectedReferences = {};
        return;
    }
    selectedReferences = referencesHash;

    if (target === undefined || target === null) {
        return;
    }

    for (var key in selectedReferences) {
        for (var i = 0; i < selectedReferences[key].length; i++) {
            addReferenceToTarget(key, selectedReferences[key][i], null, target, generator);
        }
    }
}

/**
 * Loads a list under the provided key. If the key holds a list, it will be overridden.
 * Also renders the objects within the list under the given target using the provided generator.
 *
 * @param key The key under which the list should be stored
 * @param list The list (or array) of objects to store
 * @param target The jQuery selector where the elements of this list should be shown
 * @param generator The HTML elements generator to be used when rendering the elements
 */
function setList(key, list, target, generator) {
    if (list === undefined || list === null) {
        otherObjectLists[key] = [];
        return;
    }

    otherObjectLists[key] = list;

    if (target === undefined || target === null) {
        return;
    }

    for (var i = 0; i < otherObjectLists[key].length; i++) {
            addReferenceToTarget(key, otherObjectLists[key][i], null, target, generator);
    }
}

/**
 * Gets the HTML ID that corresponds to which modal should be used for the given model
 * name.
 *
 * @param klass The model name
 * @returns {string} The correspoding ID
 */
function getModalId(klass) {
    return klass === 'Position' ? '#positions-modal' : '#table-modal';
}

/**
 * Gets the currently shown modal's title.
 */
function getCurrentModalTitle() {
    return currentOptions['modalTitle'];
}

/**
 * Renders the modal by injecting the content into the correct modal via an Ajax call.
 *
 * @param resetTabs Whether the tabs within the modal should be reset or not. This will only
 *   be done if the modal's HTML ID is `#table-modal`.
 * @param extra Any extra content that the URL should have. This will be parsed by the modal's
 *   content itself to render things differently if needed. For example, when rendering
 *   `Positions`, and only those where `area == true` should be selectable, `'area'` can be
 *   passed as extra to make this possible.
 */
function renderReferencesModal(resetTabs, extra) {
    var addedParam = (extra === undefined || extra === '') ? '/noextra' : ('/' + extra);

    $.ajax({url: '/referables/' + currentOptions['klass'] + addedParam});

    if (getModalId(currentOptions['klass']) === '#table-modal' && resetTabs) {
        $('#references-tabs').find('a[data-target="#table"]').tab('show');
    }
}

/**
 * Sets the modal's title to the one stored in `currentOptions` and then shows the modal
 * to the user.
 */
function showReferencesModal() {
    var htmlId = getModalId(currentOptions['klass']);

    $(htmlId + '-title').html('Seleccionar ' + currentOptions['modalTitle']);
    $(htmlId).modal();
}

/**
 * Renders the modal with the given extras (not resetting the tabs) and then shows it
 * to the user.
 *
 * @param extra The extra render options.
 *
 * @see renderReferencesModal
 * @see showReferencesModal
 */
function renderAndShowReferencesModal(extra) {
    renderReferencesModal(false, extra);
    showReferencesModal();
}

/**
 * Processes the event of clicking on an object's row.
 *
 * @param selector The jQuery selector for the element that was clicked.
 * @param objectId The ID (database-wise) of the object clicked.
 * @param name The displayable name of the clicked object.
 */
function processReferenceRowClick(selector, objectId, name) {
    if (!checkOptions()) {
        return false;
    }

    if (!currentOptions['multiple']) {
        addReferenceToTarget(null, objectId, name);
        return true;
    }

    var isReference = currentOptions['listKey'] === false;
    var key = isReference ? currentOptions['klass'] : currentOptions['listKey'];

    var selected = isSelected(isReference, key, objectId);

    if (selected) {
        removeReference(isReference, key, objectId);
        removeReferenceFromTarget(objectId);
        selected = false;
    } else {
        addReference(isReference, key, objectId);
        addReferenceToTarget(key, objectId, name);
        selected = true;
    }

    styleSelection(selector, selected);
}

/**
 * Processes the event of creating a new object within a references modal.
 *
 * @param formResponse The JSON response the form creates after creating the object.
 *   It must include an`object_id` and an `object_name`
 */
function processNewReferenceCreated(formResponse) {
    if (!checkOptions()) {
        return
    }

    var isReference = currentOptions['listKey'] === false;
    var key = isReference ? currentOptions['klass'] : currentOptions['listKey'];
    var objectId = formResponse['object_id'];
    var objectName = formResponse['object_name'];

    if (currentOptions['multiple']) {
        addReference(isReference, key, objectId);
        renderReferencesModal(true);
    }

    addReferenceToTarget(key, objectId, objectName);
    return true;
}

/**
 * Checks whether the given ID (database-wise) is selected or not.
 *
 * @param reference True if it should look on the references list, false
 *   if it should look under other lists.
 * @param key The key (Usually model's name) to look under.
 * @param objectId The ID to look for.
 *
 * @returns {boolean} True if the object is selected, false otherwise.
 */
function isSelected(reference, key, objectId) {
    if (reference) {
        return (key in selectedReferences) &&
            (selectedReferences[key].includes(objectId));
    } else {
        return (key in otherObjectLists) &&
            (otherObjectLists[key].includes(objectId));
    }
}

/**
 * Adds the object to list of selected objects.
 *
 * @param reference True if it's a reference, thus it should be added to the
 *   references list, or false if it should be added to the extras list
 * @param key The key it should be added under
 * @param objectId The ID of the object that needs to be stored
 */
function addReference(reference, key, objectId) {
    addToHash(reference ? selectedReferences : otherObjectLists, key, objectId);
}

/**
 * Removes the object from list of selected objects.
 *
 * @param reference True if it's a reference, thus it should be removed from the
 *   references list, or false if it should be removed from the extras list
 * @param key The key it should be removed from
 * @param objectId The ID of the object that needs to be removed
 */
function removeReference(reference, key, objectId) {
    if (isSelected(reference, key, objectId)) {
        removeFromHash(reference ? selectedReferences : otherObjectLists, key, objectId)
    }
}

/**
 * Appends an HTML element to the target to visually show that an object has been added.
 *
 * @param klass The class's (model's) name
 * @param id The ID of the object that has been added
 * @param name The displayable name of the object
 * @param target The HTML selector to which the generated element will be added to
 * @parma generator The function to use when adding elements. If not defined,
 *   will default to the one stored in currentOptions
 */
function addReferenceToTarget(klass, id, name, target, generator) {
    if (target === undefined) {
        target = currentOptions['target'];
    }
    if (generator === undefined) {
        generator = currentOptions['elementGenerator'];
    }
    generator(target, klass, id, name);
}

/**
 * Removes the visual representation of an added object.
 *
 * @param target The parent HTML element from where the object is being removed.
 * @param id The ID of the object being removed
 */
function removeReferenceFromTarget(id, target) {
    if (target === undefined) {
        target = currentOptions['target'];
    }
    currentOptions['elementRemover'](target, id);
}

/**
 * Styles all of the elements on the given jQuery selector according to whether
 * the objects they represent have been selected or not. Their IDs are extracted via
 * the `data-id` attribute.
 *
 * This is done using the `currentOptions`, thus it knows if it needs to search under
 * references or another list.
 *
 * @param rows The jQuery selector containing all rows (or other representation) of the
 *   selectable items
 */
function styleSelectedRows(rows) {
    if (!currentOptions['multiple']) {
        return;
    }

    var isReference = currentOptions['listKey'] === false;
    var key = isReference ? currentOptions['klass'] : currentOptions['listKey'];

    rows.each(function () {
        var row = $(this);
        styleSelection(
            row,
            isSelected(
                isReference,
                key,
                row.attr('data-id')
            )
        );
    });
}

/**
 * Appends an HTML element to visually represent a selected object within the given target.
 *
 * This can be overriden by setting a custom element generator.
 *
 * @param target The jQuery selector where the element should be placed
 * @param klass The class's (model's) name the object belongs to
 * @param id The object's ID
 * @param name The displayable name of the object
 * @returns {string} The HTML element
 *
 * @see setElementGenerator
 */
function defaultReferenceElementGenerator(target, klass, id, name) {
    target.append(
        '<div id="reference-' + id + '" style="margin: 0 50px">\n' +

        '<input class="form-control-hidden" type="hidden" ' +
        'name="references[' + klass + '][]" id="references_' + klass + '" ' +
        'value="' + id + '">\n' +

        '<input class="form-control" readonly="readonly" type="text" ' +
        'name="references-extra[' + klass + '][]" id="references-extra_' + klass + '" ' +
        'value="' + currentOptions['modalTitle'] + ': ' + name + '">\n' +

        '</div>'
    );
}

/**
 * Removes an HTML element to visually represent the removal of an object
 *
 * This can be overridden by setting a custom element remover.
 *
 * @param target The parent element from which the object is visually being removed.
 * @param id The ID of the object being removed.
 *
 * @see setElementRemover
 */
function defaultElementRemover(target, id) {
    var reference = target.find('#reference-' + id);
    if (reference.length > 0) {
        reference.remove();
    }
}

/**
 * Registers a selection visually when the multiple selection is off.
 *
 * @param target The target selector, where the selection should be shown.
 * @param klass The selected object's class
 * @param id The object's ID
 * @param name The object's name
 */
function defaultSingleElementGenerator(target, klass, id, name) {
    target.find('.form-control').val(name);
    target.find('.form-control-hidden').val(id);
}

/**
 * Styles a given jQuery selector with a background color, depending
 * if the object represented by this selector has been selected or not.
 *
 * @param selector The jQuery selector.
 * @param selected Whether the represented object has been selected or not.
 *
 * @see SELECTED_BACKGROUND_COLOR
 * @see UNSELECTED_BACKGROUND_COLOR
 */
function styleSelection(selector, selected) {
    selector.css('background-color',
        selected ? SELECTED_BACKGROUND_COLOR : UNSELECTED_BACKGROUND_COLOR);
}

/** Adds an `element` to a list under `key` within the given `hash`. */
function addToHash(hash, key, element) {
    if (!(key in hash)) {
        hash[key] = [];
    }

    if (!(hash[key].includes(element))) {
        hash[key].push(element);
    }
}

/** Removes an `element` from a list under `key` within the given `hash`. */
function removeFromHash(hash, key, element) {
    var index = hash[key].indexOf(element);
    if (index !== -1) {
        hash[key].splice(index, 1);
    }
}
