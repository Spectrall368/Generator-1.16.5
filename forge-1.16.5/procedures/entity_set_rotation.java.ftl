{
    Entity _ent = ${input$entity};
    _ent.rotationYaw = ${opt.toFloat(input$yaw)};
    _ent.rotationPitch = ${opt.toFloat(input$pitch)};
    _ent.setRenderYawOffset(_ent.rotationYaw);
    _ent.prevRotationYaw = _ent.rotationYaw;
    if(_ent instanceof LivingEntity) {
        ((LivingEntity) _ent).prevRenderYawOffset = entity.rotationYaw;
        ((LivingEntity) _ent).rotationYawHead = entity.rotationYaw;
        ((LivingEntity) _ent).prevRotationYawHead = entity.rotationYaw;
	}
}
