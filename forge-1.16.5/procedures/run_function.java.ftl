<#include "mcelements.ftl">
if(world instanceof ServerWorld && ((ServerWorld) world).getServer() != null) {
	Optional<FunctionObject> _fopt = ((ServerWorld) world).getServer().getFunctionManager().get(${toResourceLocation(input$function)});
	if(_fopt.isPresent())
		((ServerWorld) world).getServer().getFunctionManager().execute(_fopt.get(),
			new CommandSource(ICommandSource.DUMMY, new Vector3d(${input$x}, ${input$y}, ${input$z}), Vector2f.ZERO,
				((ServerWorld) world), 4, "", new StringTextComponent(""), ((ServerWorld) world).getServer(), null));
}
