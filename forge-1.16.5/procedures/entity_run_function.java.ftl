<#include "mcelements.ftl">
{
	Entity _ent = ${input$entity};
	if(!_ent.world.isRemote() && _ent.world.getServer() != null) {
		Optional<FunctionObject> _fopt = _ent.world.getServer().getFunctionManager().get(${toResourceLocation(input$function)});
		if(_fopt.isPresent())
			_ent.world.getServer().getFunctionManager().execute(_fopt.get(), _ent.getCommandSource());
	}
}
