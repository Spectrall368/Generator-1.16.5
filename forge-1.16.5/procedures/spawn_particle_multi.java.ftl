if(world instanceof ServerWorld)
		((ServerWorld) world).spawnParticle(${generator.map(field$particle, "particles")}, ${input$x}, ${input$y}, ${input$z}, ${opt.toInt(input$count)}, ${input$dx}, ${input$dy}, ${input$dz}, ${input$speed});
