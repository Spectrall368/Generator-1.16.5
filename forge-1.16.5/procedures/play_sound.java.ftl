<#include "mcelements.ftl">
if (world instanceof World) {
	if (!((World) world).isRemote()) {
		((World) world).playSound(null, ${toBlockPos(input$x,input$y,input$z)},
	    	ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${generator.map(field$sound, "sounds")?replace("CUSTOM:", "${modid}:")}")),
			SoundCategory.${generator.map(field$soundcategory!"neutral", "soundcategories")}, ${opt.toFloat(input$level)}, ${opt.toFloat(input$pitch)});
	} else {
		((World) world).playSound(${input$x}, ${input$y}, ${input$z},
	    	ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${generator.map(field$sound, "sounds")?replace("CUSTOM:", "${modid}:")}")),
			SoundCategory.${generator.map(field$soundcategory!"neutral", "soundcategories")}, ${opt.toFloat(input$level)}, ${opt.toFloat(input$pitch)}, false);
	}
}
