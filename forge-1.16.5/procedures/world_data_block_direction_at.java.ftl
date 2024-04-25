<#include "mcelements.ftl">
(new Object() {
	public Direction getDirection(BlockPos pos){
		BlockState _bs = world.getBlockState(pos);
		Property<?> property = _bs.getBlock().getStateContainer().getProperty("facing");
		if (property != null && _bs.get(property) instanceof Direction)
			return ((Direction) _bs.get(property));
		else if (_bs.hasProperty(BlockStateProperties.AXIS))
			return Direction.getFacingFromAxisDirection(_bs.get(BlockStateProperties.AXIS), Direction.AxisDirection.POSITIVE);
		else if (_bs.hasProperty(BlockStateProperties.HORIZONTAL_AXIS))
			return Direction.getFacingFromAxisDirection(_bs.get(BlockStateProperties.HORIZONTAL_AXIS), Direction.AxisDirection.POSITIVE);
		return Direction.NORTH;
}}.getDirection(${toBlockPos(input$x,input$y,input$z)}))
