new LiquidsConfig(
<#if field$state.startsWith("CUSTOM:")>
<#assign fluid = field$state?replace("CUSTOM:", "")>
${JavaModName}Fluids.${fluid?ends_with(":Flowing")?then("FLOWING_","")}${generator.getRegistryNameForModElement(fluid?remove_ending(":Flowing"))?upper_case}.get().getDefaultState()
<#else>
Fluids.${generator.map(field$state, "fluids")}.getDefaultState()
</#if>, ${field$requires_block_below?lower_case}, ${field$rock_count}, ${field$hole_count}, ImmutableSet.of(${input$valid_blocks}))
