<@head>if (world instanceof World) {
	ScorePlayerTeam _pt = world.getScoreboard().getPlayersTeam(${input$name});
	if (_pt != null) {
</@head>
		_pt.setAllowFriendlyFire(${input$condition});
<@tail>
	}
}</@tail>