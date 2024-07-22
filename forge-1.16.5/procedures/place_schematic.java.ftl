<#include "mcelements.ftl">
if (world instanceof ServerWorld) {
	Template template = ((ServerWorld) world).getStructureTemplateManager().getTemplateDefaulted(new ResourceLocation("${modid}", "${field$schematic}"));
	if (template != null) {
		template.func_237146_a_(((ServerWorld) world),
				${toBlockPos(input$x,input$y,input$z)},
				${toBlockPos(input$x,input$y,input$z)},
				new PlacementSettings()
						.setRotation(Rotation.${field$rotation!'NONE'})
						.setMirror(Mirror.${field$mirror!'NONE'})
						.setIgnoreEntities(false), ((ServerWorld) world).rand, 3);
	}
}
