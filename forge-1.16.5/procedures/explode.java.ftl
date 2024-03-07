if (world instanceof World && !((World) world).isRemote())
	((World) world).createExplosion(null, ${input$x}, ${input$y}, ${input$z}, ${opt.toFloat(input$power)}, Explosion.Mode.${field$mode!"BREAK"});
