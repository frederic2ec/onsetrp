
function rgb2hex(rgb){
	rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
	return (rgb && rgb.length === 4) ?
	 ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
	 ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
	 ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
}

$(document).ready(function() {

	$("#buy").click(function() {
		modelid = $(".badge-danger").parent("a").attr("id");
		color = rgb2hex( $("#color").val() );
		CallEvent("buyCar", modelid, color);
		$("a").find("span").removeClass("badge-danger").addClass("badge-primary")
	});

	$("#close").click(function() {

		CallEvent("closeCarDealer");
	});
});

$(function () {
	// Basic instantiation:
	$('#color').colorpicker();
});

function addCarList(modelid, name, price) {
	let object = '<a href="#" id="'+ modelid +'" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" onclick="selectCar(this)">' + name + '<span class="badge badge-primary badge-pill">' + price + '$</span></a>';
	$('#carList').append(object);
}

function selectCar(object) {
	$("a").not(object).find("span").removeClass("badge-danger").addClass("badge-primary")
	$(object).find("span").removeClass("badge-primary").addClass("badge-danger")
}