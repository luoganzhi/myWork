function showPic(whichpic) {
			var source = whichpic.getAttribute("href");
			var plaecholder = document.getElementById("placeholder")
			placeholder.setAttribute("src", source)
			var text = whichpic.getAttribute("title");
			var description = document.getElementById("description");
			description.firstChild.nodeValue = text;
			// alert(description.firstChild.nodeValue)
}

function popUp(withURL) {
	window.open(withURL,"popup",
		"width=320, height=480");
}