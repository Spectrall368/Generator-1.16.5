<@head>if (world instanceof World) {
	ScorePlayerTeam _pt = world.getScoreboard().getTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setDeathMessageVisibility(Team.Visible.${field$visibility});
<@tail>
	}
}</@tail>