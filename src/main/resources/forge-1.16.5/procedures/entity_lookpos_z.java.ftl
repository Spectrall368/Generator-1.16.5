/*@int*/(${input$entity}.world.rayTraceBlocks(new RayTraceContext(${input$entity}.getEyePosition(1f), ${input$entity}.getEyePosition(1f)
    .add(${input$entity}.getLook(1f).scale(${input$maxdistance})), RayTraceContext.BlockMode.${field$block_mode!"OUTLINE"},
    RayTraceContext.FluidMode.${field$fluid_mode!"NONE"}, ${input$entity})).getPos().getZ())
