//= require chartist
//= require dist/chartist-plugin-tooltip

function generateLineChart(id, data, opts) {
    opts['plugins'] = [
        Chartist.plugins.tooltip({
            tooltipFnc: function (meta, value) {
                var coords = value.split(',');
                return coords.length < 2 ? coords[0] : coords[1];
            }
        })
    ];

    return Chartist.Line(id, data, opts);
}

function generateFixedAxis(values, min, max, labelFnc) {
    return {type: Chartist.FixedScaleAxis,
        low: min, high: max,
        ticks: values, labelInterpolationFnc: labelFnc};
}

function generateAutoAxis(min, max) {
    return {type: Chartist.AutoScaleAxis, low: min, high: max};
}
