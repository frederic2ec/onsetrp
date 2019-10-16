function changeHealth(health) {
	$("#health")
      .css("width", health + "%")
      .attr("aria-valuenow", health)
      .text("Health : " + health + "%"); 
}

function changeArmor(armor) {
	$("#armor")
      .css("width", armor + "%")
      .attr("aria-valuenow", armor)
      .text("Armor : " + armor + "%"); 
}

function changeHunger(hunger) {
	$("#hunger")
      .css("width", hunger + "%")
      .attr("aria-valuenow", hunger)
      .text("Hunger : " + hunger + "%"); 
}

function changeThirst(thirst) {
	$("#thirst")
      .css("width", thirst + "%")
      .attr("aria-valuenow", thirst)
      .text("Thirst : " + thirst + "%"); 
}