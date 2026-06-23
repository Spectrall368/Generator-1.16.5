{
	Entity _ent = ${input$entity};
	double _tx = ${input$x};
	double _ty = ${input$y};
	double _tz = ${input$z};
	_ent.setPositionAndUpdate(_tx, _ty, _tz);
	if (_ent instanceof ServerPlayerEntity)
		((ServerPlayerEntity) _ent).connection.setPlayerLocation(_tx, _ty, _tz, _ent.rotationYaw, _ent.rotationPitch);
}