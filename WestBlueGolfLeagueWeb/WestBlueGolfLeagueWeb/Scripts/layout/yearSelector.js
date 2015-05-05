$('#yearSelector').on('change', function() {
	document.cookie = "westBlueYear=" + this.value + ";path=/;";
	window.location.reload(true);
});