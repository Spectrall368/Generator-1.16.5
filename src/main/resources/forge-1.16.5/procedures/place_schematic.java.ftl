<#include "mcelements.ftl">
if (world instanceof ServerWorld) {
	Template template = ((ServerWorld) world).getStructureTemplateManager().getTemplateDefaulted(new ResourceLocation("${modid}", "${field$schematic}"));
	if (template != null) {
		template.func_237146_a_((ServerWorld) world,
			${toBlockPos(input$x,input$y,input$z)},
			${toBlockPos(input$x,input$y,input$z)},
			new PlacementSettings()
				.setRotation(Rotation.<#if (field$rotation!'NONE') != "RANDOM">${field$rotation!'NONE'}<#else>randomRotation(((ServerWorld) world).rand)</#if>)
				.setMirror(Mirror.<#if (field$mirror!'NONE') != "RANDOM">${field$mirror!'NONE'}<#else>values()[((ServerWorld) world).rand.nextInt(2)]</#if>)
				.setIgnoreEntities(false), ((ServerWorld) world).rand, 3);
	}
}
