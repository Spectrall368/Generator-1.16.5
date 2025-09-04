if (world instanceof World) {
	ScorePlayerTeam _pt = ((World) world).getScoreboard().getTeam(${input$name});
	if (_pt != null)
		((World) world).getScoreboard().removeTeam(_pt);
}