<#macro boundingBoxWithRotation boundingBox rotationMode=0 enablePitch=false>
	<#assign positiveBoxes = boundingBox.positiveBoundingBoxes()>
	<#assign negativeBoxes = boundingBox.negativeBoundingBoxes()>
	<#if boundingBox.isBoundingBoxEmpty()>
		<#if rotationMode == 0>VoxelShapes.empty()<#else>return VoxelShapes.empty();</#if>
	<#elseif rotationMode == 0>
		<@makeBoundingBox positiveBoxes negativeBoxes "north"/>
	<#else>
		<#if rotationMode != 5>
			<#assign pitch = (rotationMode == 1 || rotationMode == 3) && enablePitch>
			switch (state.get(FACING)) {
				case NORTH:
				    <@checkPitchSupport positiveBoxes negativeBoxes "north" pitch/>
				case EAST:
				    <@checkPitchSupport positiveBoxes negativeBoxes "east" pitch/>
				case WEST:
				    <@checkPitchSupport positiveBoxes negativeBoxes "west" pitch/>
				<#if rotationMode == 2 || rotationMode == 4>
				case UP:
				    return <@makeBoundingBox positiveBoxes negativeBoxes "up"/>;
				case DOWN:
				    return <@makeBoundingBox positiveBoxes negativeBoxes "down"/>;
				</#if>
				default:
				    <@checkPitchSupport positiveBoxes negativeBoxes "south" pitch/>
			}
		<#else>
			switch (state.get(AXIS)) {
				case X:
				    return <@makeBoundingBox positiveBoxes negativeBoxes "x"/>;
				case Y:
				    return <@makeBoundingBox positiveBoxes negativeBoxes "y"/>;
				default:
				    return <@makeBoundingBox positiveBoxes negativeBoxes "z"/>;
			}
		</#if>
	</#if>
</#macro>

<#macro makeBoundingBox positiveBoxes negativeBoxes facing pitchType="floor">
	<#if negativeBoxes?size != 0>VoxelShapes.combineAndSimplify(</#if>
	<@mergeBoxes positiveBoxes, facing, pitchType/>
	<#if negativeBoxes?size != 0>
	, <@mergeBoxes negativeBoxes, facing, pitchType/>, IBooleanFunction.ONLY_FIRST)</#if>
</#macro>

<#macro checkPitchSupport positiveBoxes negativeBoxes facing enablePitch>
	<#if enablePitch>
		switch (state.get(FACE)) {
			case FLOOR:
			    return <@makeBoundingBox positiveBoxes negativeBoxes facing "floor"/>;
			case WALL:
			    return <@makeBoundingBox positiveBoxes negativeBoxes facing "wall"/>;
			default:
			    return <@makeBoundingBox positiveBoxes negativeBoxes facing "ceiling"/>;
		}
	<#else>
		return <@makeBoundingBox positiveBoxes negativeBoxes facing/>;
	</#if>
</#macro>

<#macro makeCuboid box facing pitchType>
	<#if facing == "south">
		<#if pitchType == "floor">
			makeCuboidShape(${min(16 - box.mx, 16 - box.Mx)}, ${min(box.my, box.My)}, ${min(16 - box.mz, 16 - box.Mz)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(box.my, box.My)}, ${max(16 - box.mz, 16 - box.Mz)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(box.mx, box.Mx)}, ${min(16 - box.my, 16 - box.My)}, ${min(16 - box.mz, 16 - box.Mz)},
			${max(box.mx, box.Mx)}, ${max(16 - box.my, 16 - box.My)}, ${max(16 - box.mz, 16 - box.Mz)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(16 - box.mx, 16 - box.Mx)}, ${min(box.mz, box.Mz)}, ${min(box.my, box.My)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(box.mz, box.Mz)}, ${max(box.my, box.My)})
		</#if>
	<#elseif facing == "east">
		<#if pitchType == "floor">
			makeCuboidShape(${min(16 - box.mz, 16 - box.Mz)}, ${min(box.my, box.My)}, ${min(box.mx, box.Mx)},
			${max(16 - box.mz, 16 - box.Mz)}, ${max(box.my, box.My)}, ${max(box.mx, box.Mx)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(16 - box.mz, 16 - box.Mz)}, ${min(16 - box.my, 16 - box.My)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(16 - box.mz, 16 - box.Mz)}, ${max(16 - box.my, 16 - box.My)}, ${max(16 - box.mx, 16 - box.Mx)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(box.my, box.My)}, ${min(box.mz, box.Mz)}, ${min(box.mx, box.Mx)},
			${max(box.my, box.My)}, ${max(box.mz, box.Mz)}, ${max(box.mx, box.Mx)})
		</#if>
	<#elseif facing == "west">
		<#if pitchType == "floor">
			makeCuboidShape(${min(box.mz, box.Mz)}, ${min(box.my, box.My)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(box.mz, box.Mz)}, ${max(box.my, box.My)}, ${max(16 - box.mx, 16 - box.Mx)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)}, ${min(box.mx, box.Mx)},
			${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)}, ${max(box.mx, box.Mx)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(16 - box.my, 16 - box.My)}, ${min(box.mz, box.Mz)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(16 - box.my, 16 - box.My)}, ${max(box.mz, box.Mz)}, ${max(16 - box.mx, 16 - box.Mx)})
		</#if>
	<#elseif facing == "up">
		makeCuboidShape(${min(box.mx, box.Mx)}, ${min(16 - box.mz, 16 - box.Mz)}, ${min(box.my, box.My)},
		${max(box.mx, box.Mx)}, ${max(16 - box.mz, 16 - box.Mz)}, ${max(box.my, box.My)})
	<#elseif facing == "down" || facing == "z">
		makeCuboidShape(${min(box.mx, box.Mx)}, ${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)},
		${max(box.mx, box.Mx)}, ${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)})
	<#elseif facing == "x">
		makeCuboidShape(${min(box.my, box.My)}, ${min(box.mz, box.Mz)}, ${min(box.mx, box.Mx)},
		${max(box.my, box.My)}, ${max(box.mz, box.Mz)}, ${max(box.mx, box.Mx)})
	<#else>
		<#if pitchType == "floor">
			makeCuboidShape(${min(box.mx, box.Mx)}, ${min(box.my, box.My)}, ${min(box.mz, box.Mz)},
			${max(box.mx, box.Mx)}, ${max(box.my, box.My)}, ${max(box.mz, box.Mz)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(16 - box.mx, 16 - box.Mx)}, ${min(16 - box.my, 16 - box.My)}, ${min(box.mz, box.Mz)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(16 - box.my, 16 - box.My)}, ${max(box.mz, box.Mz)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(box.mx, box.Mx)}, ${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)},
			${max(box.mx, box.Mx)}, ${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)})
		</#if>
	</#if>
</#macro>

<#function min(a, b)>
	<#return (a < b)?then(a, b)>
</#function>

<#function max(a, b)>
	<#return (a > b)?then(a, b)>
</#function>

<#macro mergeBoxes boxes facing pitchType>
	<#if boxes?size == 1>
		<@makeCuboid boxes.get(0) facing pitchType/>
	<#else>
	VoxelShapes.or(<#list boxes as box>
		<@makeCuboid box facing pitchType/><#sep>,</#list>)
	</#if>
</#macro>