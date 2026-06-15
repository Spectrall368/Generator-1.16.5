<@head>if (${input$entity} instanceof PlayerEntity) {
	PlayerEntity _player = (PlayerEntity) ${input$entity};</@head>
	_player.abilities.isFlying = ${input$condition};
<@tail>
	_player.sendPlayerAbilities();
}</@tail>