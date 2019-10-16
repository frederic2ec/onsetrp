$(document).ready(function() {

	$("#withdraw").click(function() {
		let amount = $('#amount').val();

		CallEvent("withdrawMoney", amount);
	});

	$("#deposit").click(function() {
		let amount = $('#amount').val();

		CallEvent("depositMoney", amount);
	});

	$("#close").click(function() {

		CallEvent("closeAtm");
	});
});


function changeBank(bank) {
	$("#bank")
      .text("Bank account : " + bank + "$"); 
}

function changeCash(cash) {
	$("#cash")
      .text("Cash : " + cash + "$"); 
}