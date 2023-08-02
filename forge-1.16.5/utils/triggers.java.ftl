<#macro bonemealEvents isBonemealTargetCondition="" bonemealSuccessCondition="" onBonemealSuccess="">
@Override public boolean isValidBonemealTarget(BlockGetter worldIn, BlockPos pos, BlockState blockstate, boolean clientSide) {
	<#if hasProcedure(isBonemealTargetCondition)>
	if (worldIn instanceof IWorld world) {
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();
		return <@procedureOBJToConditionCode isBonemealTargetCondition/>;
	}
	return false;
	<#else>
	return true;
	</#if>
}

@Override public boolean isBonemealSuccess(IWorld world, Random random, BlockPos pos, BlockState blockstate) {
	<#if hasProcedure(bonemealSuccessCondition)>
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();
		return <@procedureOBJToConditionCode bonemealSuccessCondition/>;
	<#else>
	return true;
	</#if>
}

@Override public void performBonemeal(IWorld world, Random random, BlockPos pos, BlockState blockstate) {
	<#if hasProcedure(onBonemealSuccess)>
	<@procedureCode onBonemealSuccess, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate"
	}/>
	</#if>
}
</#macro>
