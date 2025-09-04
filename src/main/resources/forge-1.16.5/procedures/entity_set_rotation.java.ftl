{
	Entity _ent = ${input$entity};
	_ent.rotationYaw = ${opt.toFloat(input$yaw)};
	_ent.rotationPitch = ${opt.toFloat(input$pitch)};
	_ent.setRenderYawOffset(_ent.rotationYaw);
	_ent.setRotationYawHead(_ent.rotationYaw);
	_ent.prevRotationYaw = _ent.rotationYaw;
	_ent.prevRotationPitch = _ent.rotationPitch;
	if (_ent instanceof LivingEntity) {
		((LivingEntity) _ent).prevRenderYawOffset = ((LivingEntity) _ent).rotationYaw;
		((LivingEntity) _ent).prevRotationYawHead = ((LivingEntity) _ent).rotationYaw;
	}
}
