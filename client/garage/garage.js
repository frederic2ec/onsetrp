$(document).ready(function() {

	$("#spawn").click(function() {
		id = $(".badge-danger").parent("a").attr("id")
		CallEvent("spawnCar", id);
		$("a").find("span").removeClass("badge-danger").addClass("badge-primary")
	});
	$("#sell").click(function() {
		id = $(".badge-danger").parent("a").attr("id")
		CallEvent("sellCar", id);
		$("a").find("span").removeClass("badge-danger").addClass("badge-primary")
	});

	$("#close").click(function() {
		CallEvent("closeGarageDealer");
	});
});


function clearGarage() {
	$('#garageList').empty();
}

function addGarageList(id, name, price, color) {
	let object = '<a href="#" id="'+ id +'" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" onclick="selectCar(this)">' + name + '<span class="badge badge-pill" style="background-color: #' + color + ';">Color</span><span class="badge badge-primary badge-pill">' + price + '$</span></a>';
	$('#garageList').append(object);
}

function selectCar(object) {
	$("a").not(object).find("span").removeClass("badge-danger").addClass("badge-primary")
	$(object).find("span").removeClass("badge-primary").addClass("badge-danger")
}