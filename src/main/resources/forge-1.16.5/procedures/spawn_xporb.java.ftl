if(world instanceof ServerWorld)
	((ServerWorld) world).addEntity(new ExperienceOrbEntity(((ServerWorld) world), ${input$x}, ${input$y}, ${input$z}, ${opt.toInt(input$xpamount)}));
