<#if generator.map(field$gamerulesnumber, "gamerules") != "null">
if(!world.isRemote() && world.getServer() != null) {
	world.getServer().getCommandManager().handleCommand(
		new CommandSource(ICommandSource.DUMMY, Vector3d.ZERO, Vector2f.ZERO, ((ServerWorld) world),
			4, "", new StringTextComponent(""), world.getServer(), null).withFeedbackDisabled(),
				String.format("gamerule %s %d", (${generator.map(field$gamerulesnumber, "gamerules")}).toString(), ${opt.toInt(input$gameruleValue)}));
}
</#if>
