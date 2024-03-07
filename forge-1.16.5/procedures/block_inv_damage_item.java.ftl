<#include "mcelements.ftl">
<#-- @formatter:off -->
{
	TileEntity _ent = world.getTileEntity(${toBlockPos(input$x,input$y,input$z)});
	if (_ent != null) {
		final int _slotid = ${opt.toInt(input$slotid)};
		final int _amount = ${opt.toInt(input$amount)};
		_ent.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> {
			if (capability instanceof IItemHandlerModifiable) {
				ItemStack _stk = capability.getStackInSlot(_slotid).copy();
				if(_stk.attemptDamageItem(_amount, new Random(), null)) {
	    				_stk.shrink(1);
	    				_stk.setDamage(0);
				}
				((IItemHandlerModifiable) capability).setStackInSlot(_slotid, _stk);
			}
		});
	}
}
<#-- @formatter:on -->
