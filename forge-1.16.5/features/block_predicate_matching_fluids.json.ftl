ImmutableList.of(
<#if field$fluid.startsWith("CUSTOM:")>
<#assign fluid = field$fluid?replace("CUSTOM:", "")>
${JavaModName}Fluids.${fluid?ends_with(":Flowing")?then("FLOWING_","")}${generator.getRegistryNameForModElement(fluid?remove_ending(":Flowing"))?upper_case}.get().getDefaultState()
<#else>
Fluids.${generator.map(field$fluid, "fluids")}.getDefaultState()
</#if>).contains(world.getFluidState(placePos<#if (field$x != "0")||(field$y != "0")||(field$z != "0")>.add(${field$x}, ${field$y}, ${field$z})</#if>).getBlockState())
