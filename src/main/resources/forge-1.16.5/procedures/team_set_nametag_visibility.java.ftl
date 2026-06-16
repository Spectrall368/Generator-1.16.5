<@head>if (world instanceof World) {
	ScorePlayerTeam _pt = ((World) world).getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setNameTagVisibility(Team.Visible.${field$visibility});
<@tail>
	}
}</@tail>