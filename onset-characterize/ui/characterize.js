
$(document).ready(function() {
    $('#close').click(function(e) {
        e.preventDefault();
        CallEvent("characterize:HidePanel");
    });
    
    $('#characterize-form').submit(function(e) {
        e.preventDefault();
        CallEvent("characterize:Submit", JSON.stringify($(this).serializeArray()));
    });

    $('#preset').on('input', function () {
        $('#preset_value').html($(this).val());
        CallEvent("characterize:Change", 'preset', $(this).val());
    });

    $('#body').on('input', function () {
        $('#body_value').html($(this).val());
        CallEvent("characterize:Change", 'body', bodyOptions[$(this).val() - 1]);
    });

    $('#hair').on('input', function () {
        $('#hair_value').html($(this).val());
        CallEvent("characterize:Change", 'hair', hairOptions[$(this).val() - 1]);
    });

    $('#shirt').on('input', function () {
        $('#shirt_value').html($(this).val());
        CallEvent("characterize:Change", 'shirt', shirtOptions[$(this).val() - 1]);
    });

    $('#pants').on('input', function () {
        $('#pants_value').html($(this).val());
        CallEvent("characterize:Change", 'pants', pantOptions[$(this).val() - 1]);
    });

    $('#shoes').on('input', function () {
        $('#shoes_value').html($(this).val());
        CallEvent("characterize:Change", 'shoes', shoeOptions[$(this).val() - 1]);
    });

    $("#hair_color").attr({ "max": colorOptions.length });
    $('#hair_color').on('input', function () {
        $('#hair_color_value').html($(this).val());
        CallEvent("characterize:Change", 'hair_color', colorOptions[$(this).val() - 1]);
    });

    $("#shirt_color").attr({ "max": colorOptions.length });
    $('#shirt_color').on('input', function () {
        $('#shirt_color_value').html($(this).val());
        CallEvent("characterize:Change", 'shirt_color', colorOptions[$(this).val() - 1]);
    });

    $("#pants_color").attr({ "max": colorOptions.length });
    $('#pants_color').on('input', function () {
        $('#pants_color_value').html($(this).val());
        CallEvent("characterize:Change", 'pants_color', colorOptions[$(this).val() - 1]);
    });
});

let bodyOptions;
let hairOptions;
let shirtOptions;
let pantOptions;
let shoeOptions;
const colorOptions = [
    'FF6633', 'FFB399', 'FF33FF', 'FFFF99', '00B3E6',
    'E6B333', '3366E6', '999966', '99FF99', 'B34D4D',
    '80B300', '809900', 'E6B3B3', '6680B3', '66991A',
    'FF99E6', 'CCFF1A', 'FF1A66', 'E6331A', '33FFCC',
    '66994D', 'B366CC', '4D8000', 'B33300', 'CC80CC',
    '66664D', '991AFF', 'E666FF', '4DB3FF', '1AB399',
    'E666B3', '33991A', 'CC9999', 'B3B31A', '00E680',
    '4D8066', '809980', 'E6FF80', '1AFF33', '999933',
    'FF3380', 'CCCC00', '66E64D', '4D80CC', '9900B3',
    'E64D66', '4DB380', 'FF4D4D', '99E6E6', '6666FF'
];

function SetCharacterOptions(type, options) {
    if (type == 'body') {
        bodyOptions = JSON.parse(options);
        $("#body").attr({ "max": bodyOptions.length });
    } else if (type == 'hair') {
        hairOptions = JSON.parse(options);
        $("#hair").attr({ "max": hairOptions.length });
    } else if (type == 'shirt') {
        shirtOptions = JSON.parse(options);
        $("#shirt").attr({ "max": shirtOptions.length });
    } else if (type == 'pants') {
        pantOptions = JSON.parse(options);
        $("#pants").attr({ "max": pantOptions.length });
    } else if (type == 'shoes') {
        shoeOptions = JSON.parse(options);
        $("#shoes").attr({ "max": shoeOptions.length });
    }
}