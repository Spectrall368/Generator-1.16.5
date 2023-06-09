<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	int _amount = (int)${input$amount};
	if (_ent != null)
		_ent.getCapability(CapabilityFluidHandler.FLUID_HANDLER_CAPABILITY, ${input$direction}).ifPresent(capability ->
			<#if field$fluid.startsWith("CUSTOM:")>
				<#if field$fluid.endsWith(":Flowing")>
				capability.fill(new FluidStack(${(field$fluid.replace("CUSTOM:", "").replace(":Flowing", ""))}Block.flowing, _amount), IFluidHandler.FluidAction.EXECUTE)
				<#else>
				capability.fill(new FluidStack(${(field$fluid.replace("CUSTOM:", ""))}Block.still, _amount), IFluidHandler.FluidAction.EXECUTE)
				</#if>
			<#else>
			capability.fill(new FluidStack(Fluids.${generator.map(field$fluid, "fluids")}, _amount), IFluidHandler.FluidAction.EXECUTE)
			</#if>
		);
}
<#-- @formatter:on -->
