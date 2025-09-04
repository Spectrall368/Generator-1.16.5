{
	Entity _entityTeam = ${input$entity};
	ScorePlayerTeam _pt = _entityTeam.world.getScoreboard().getTeam(${input$name});
	if (_pt != null) {
		if (_entityTeam instanceof PlayerEntity)
			_entityTeam.world.getScoreboard().removePlayerFromTeam(((PlayerEntity) _entityTeam).getGameProfile().getName(), _pt);
		else
			_entityTeam.world.getScoreboard().removePlayerFromTeam(_entityTeam.getCachedUniqueIdString(), _pt);
	}
}