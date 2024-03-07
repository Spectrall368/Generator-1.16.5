if(${input$entity} instanceof LivingEntity  && !((LivingEntity) ${input$entity}).world.isRemote())
	((LivingEntity) ${input$entity}).addPotionEffect(new EffectInstance(${generator.map(field$potion, "effects")},${opt.toInt(input$duration)},${opt.toInt(input$level)}, ${input$ambient}, ${input$particles}));
