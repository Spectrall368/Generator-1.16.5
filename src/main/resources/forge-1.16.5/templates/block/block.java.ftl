<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../boundingboxes.java.ftl">
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
<#assign filteredCustomProperties = data.customProperties?filter(e ->
 	e.property().getName().startsWith("CUSTOM:") || generator.map(e.property().getName(), "blockstateproperties") != "")>
<#assign blockSetType = "REDSTONE_LIGHT">
<#if data.blockBase?has_content>
    <#if data.blockBase == "PressurePlate" || data.blockBase == "TrapDoor" || data.blockBase == "Door" || data.blockBase == "Fence" || data.blockBase == "Button">
        <#assign blockSetType = data.blockSetType?replace("STONE", "ROCK")?replace("OAK", "NETHER_WOOD")>
    <#elseif data.blockBase == "Stairs" || data.blockBase == "Slab" || data.blockBase == "Wall">
        <#assign blockSetType = "ROCK">
    <#elseif data.blockBase == "Leaves">
        <#assign blockSetType = "LEAVES">
    <#elseif data.blockBase == "Pane">
        <#assign blockSetType = "GLASS">
    <#elseif data.isSign() || data.blockBase == "FenceGate">
        <#assign blockSetType = "NETHER_WOOD">
    <#elseif data.blockBase == "FlowerPot" || data.blockBase == "EndRod">
        <#assign blockSetType = "MISCELLANEOUS">
    </#if>
</#if>
<#if data.blockBase?has_content && data.blockBase == "Wall">
	<#assign filteredCustomProperties = []>
</#if>
package ${package}.block;

<@javacompress>
public class ${getClassName()}Block extends ${getBlockClass(data.blockBase)}

	<#assign interfaces = []>
	<#if data.isWaterloggable>
		<#assign interfaces += ["IWaterLoggable"]>
	</#if>
	<#if data.isBonemealable && !(data.blockBase?has_content && data.blockBase == "TrapDoor")>
		<#assign interfaces += ["IGrowable"]>
	</#if>
	<#if interfaces?size gt 0>
		implements ${interfaces?join(",")}
	</#if>
{

	<#if data.rotationMode == 1 || data.rotationMode == 3>
		public static final DirectionProperty FACING = HorizontalBlock.HORIZONTAL_FACING;
		<#if data.enablePitch>
		public static final EnumProperty<AttachFace> FACE = HorizontalFaceBlock.FACE;
		</#if>
	<#elseif data.rotationMode == 2 || data.rotationMode == 4>
		public static final DirectionProperty FACING = DirectionalBlock.FACING;
	<#elseif data.rotationMode == 5>
		public static final EnumProperty<Direction.Axis> AXIS = BlockStateProperties.AXIS;
	</#if>
	<#if data.isWaterloggable>
		public static final BooleanProperty WATERLOGGED = BlockStateProperties.WATERLOGGED;
	</#if>
	<#list filteredCustomProperties as prop>
		<#if prop.property().getName().startsWith("CUSTOM:")>
			<#assign propName = prop.property().getName().replace("CUSTOM:", "")>
			<#if prop.property().getClass().getSimpleName().equals("LogicType")>
				public static final BooleanProperty ${propName?upper_case} = BooleanProperty.create("${propName}");
			<#elseif prop.property().getClass().getSimpleName().equals("IntegerType")>
				public static final IntegerProperty ${propName?upper_case} = IntegerProperty.create("${propName}", ${prop.property().getMin()}, ${prop.property().getMax()});
			<#elseif prop.property().getClass().getSimpleName().equals("StringType")>
				public static final EnumProperty<${StringUtils.snakeToCamel(propName)}Property> ${propName?upper_case} = EnumProperty.create("${propName}", ${StringUtils.snakeToCamel(propName)}Property.class);
			</#if>
		<#else>
			<#assign propName = prop.property().getName()>
			<#if prop.property().getClass().getSimpleName().equals("LogicType")>
				public static final BooleanProperty ${propName?upper_case} = ${generator.map(propName, "blockstateproperties")};
			<#elseif prop.property().getClass().getSimpleName().equals("IntegerType")>
				public static final IntegerProperty ${propName?upper_case} = ${generator.map(propName, "blockstateproperties")};
			<#elseif prop.property().getClass().getSimpleName().equals("StringType")>
				public static final EnumProperty<${generator.map(propName, "blockstateproperties", 2)}> ${propName?upper_case} = ${generator.map(propName, "blockstateproperties")};
			</#if>
		</#if>
	</#list>

	<#assign defaultStateCustomShape = data.boundingBoxes?? && !data.blockBase?? && !data.isFullCube()>
	<#assign statesWithCustomShape = data.getDefinedStatesWithCustomShape()>
	<#if defaultStateCustomShape || statesWithCustomShape?has_content>
		<#if data.rotationMode == 0 && !statesWithCustomShape?has_content><#-- shape not state dependent -->
		private static final VoxelShape SHAPE = <@boundingBoxWithRotation data/>;
		<#else>
		private final ImmutableMap<BlockState, VoxelShape> shapes = this.makeShapes();
		</#if>
	</#if>

	<#macro blockProperties>
	    AbstractBlock.Properties.create(Material.${blockSetType}
		<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
		    , MaterialColor.${generator.map(data.colorOnMap, "mapcolors")}
		</#if>)
		<#if data.isCustomSoundType>
			.sound(new ForgeSoundType(1.0f, 1.0f,
				() -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.breakSound}")),
				() -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.stepSound}")),
				() -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.placeSound}")),
				() -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.hitSound}")),
				() -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.fallSound}"))
			))
		<#elseif data.soundOnStep != "STONE">
			.sound(SoundType.${data.soundOnStep})
		</#if>
		<#if data.unbreakable>
			.hardnessAndResistance(-1, 3600000)
		<#elseif (data.hardness == 0) && (data.resistance == 0)>
			.zeroHardnessAndResistance()
		<#elseif data.hardness == data.resistance>
			.hardnessAndResistance(${data.hardness}f)
		<#else>
			.hardnessAndResistance(${data.hardness}f, ${data.resistance}f)
		</#if>
		<#if hasProcedure(data.luminance) || data.luminance.getFixedValue() != 0>
			.setLightLevel(blockstate -> <#if hasProcedure(data.luminance)>(int) <@procedureOBJToNumberCode data.luminance/><#else>${data.luminance.getFixedValue()}</#if>)
		</#if>
		<#if data.requiresCorrectTool>
			.setRequiresTool()
		</#if>
		<#if data.destroyTool != "Not specified">
			.harvestLevel(<#if data.vanillaToolTier == "NONE">
				0
				<#elseif data.vanillaToolTier == "STONE">
				1
				<#elseif data.vanillaToolTier == "IRON">
				2
				<#else>
				3
				</#if>)
			.harvestTool(ToolType.${data.destroyTool?upper_case})
		</#if>
		<#if data.isNotColidable>
			.doesNotBlockMovement()
		</#if>
		<#if data.slipperiness != 0.6>
			.slipperiness(${data.slipperiness}f)
		</#if>
		<#if data.speedFactor != 1.0>
			.speedFactor(${data.speedFactor}f)
		</#if>
		<#if data.jumpFactor != 1.0>
			.jumpFactor(${data.jumpFactor}f)
		</#if>
		<#if (data.hasTransparency || data.blockBase! == "Leaves") && !data.isNotColidable> <#-- No collision implies no occlusion -->
			.notSolid()
		</#if>
		<#if data.tickRandomly>
			.tickRandomly()
		</#if>
		<#if data.emissiveRendering>
			.setNeedsPostProcessing((bs, br, bp) -> true)
			.setEmmisiveRendering((bs, br, bp) -> true)
		</#if>
		<#if data.hasTransparency>
			.setOpaque((bs, br, bp) -> false)
		</#if>
		<#if (!data.isNotColidable && data.offsetType != "NONE")>
			.variableOpacity()
		</#if>
		<#if data.blockBase?has_content && data.blockBase == "Leaves">
			.setSuffocates((bs, br, bp) -> false)
			.setBlocksVision((bs, br, bp) -> false)
		</#if>
		<#if var_extends_class! == "WallSignBlock">
			.lootFrom(${JavaModName}Blocks.${REGISTRYNAME}.get())
		</#if>
	</#macro>

	public ${getClassName()}Block() {
		<#if data.blockBase?has_content>
			<#if data.blockBase == "Stairs">
				super(() -> Blocks.AIR.getDefaultState(), <@blockProperties/>);
			<#elseif data.blockBase == "PressurePlate">
				super(Sensitivity.<#if data.blockSetType == "OAK">EVERYTHING<#else>MOBS</#if>, <@blockProperties/>);
			<#elseif data.blockBase == "FlowerPot">
				super(() -> (FlowerPotBlock) Blocks.FLOWER_POT, () -> ${mappedBlockToBlock(data.pottedPlant)}, <@blockProperties/>);
				((FlowerPotBlock) Blocks.FLOWER_POT).addPlant(new ResourceLocation("${mappedMCItemToRegistryName(data.pottedPlant)}"), () -> this);
			<#elseif data.isSign()>
				super(<@blockProperties/>, ${JavaModName}WoodTypes.${REGISTRYNAME}_WOOD_TYPE);
			<#else>
				super(<@blockProperties/>);
			</#if>
		<#else>
			super(<@blockProperties/>);
		</#if>

	    <#if data.rotationMode != 0 || data.isWaterloggable || filteredCustomProperties?has_content>
	    this.setDefaultState(this.stateContainer.getBaseState()
	    	<#if data.rotationMode == 1 || data.rotationMode == 3>
	    	.with(FACING, Direction.NORTH)
	    	    <#if data.enablePitch>
	    	    .with(FACE, AttachFace.WALL)
	    	    </#if>
	    	<#elseif data.rotationMode == 2 || data.rotationMode == 4>
	    	.with(FACING, Direction.NORTH)
	    	<#elseif data.rotationMode == 5>
	    	.with(AXIS, Direction.Axis.Y)
	    	</#if>
			<@initCustomBlockStateProperties />
	    	<#if data.isWaterloggable>
	    	.with(WATERLOGGED, false)
	    	</#if>
	    );
		</#if>
	}

	<#if data.transparencyType != "SOLID" || data.hasTransparency>
	@OnlyIn(Dist.CLIENT) public static void registerRenderLayer() {
		<#if data.transparencyType == "CUTOUT_MIPPED">
		RenderTypeLookup.setRenderLayer(${JavaModName}Blocks.${REGISTRYNAME}.get(), RenderType.getCutoutMipped());
		<#elseif data.transparencyType == "TRANSLUCENT">
		RenderTypeLookup.setRenderLayer(${JavaModName}Blocks.${REGISTRYNAME}.get(), RenderType.getTranslucent());
		<#elseif data.transparencyType == "CUTOUT" || data.hasTransparency> <#-- for cases when user selected SOLID but checked transparency -->
		RenderTypeLookup.setRenderLayer(${JavaModName}Blocks.${REGISTRYNAME}.get(), RenderType.getCutout());
		</#if>
	}
	</#if>

	<#if defaultStateCustomShape || statesWithCustomShape?has_content>
		<#if data.rotationMode != 0 || statesWithCustomShape?has_content>
		private ImmutableMap<BlockState, VoxelShape> makeShapes() {
			return this.getShapeForEachState(state -> {
				<#list statesWithCustomShape as state>
				<#if !state?is_first>else </#if>if (
    				<#list state.stateMap.keySet() as property>
						<#assign value = state.stateMap.get(property)>
						<#if property.getClass().getSimpleName().equals("StringType")>
							<#assign value = generator.map(property.getName(), "blockstateproperties", 2) + "." + value?upper_case>
						</#if>
						state.get(${property.getName().replace("CUSTOM:", "")?upper_case}) == ${value}<#sep>&&
					</#list>
				) {
					<#if data.rotationMode == 0>return</#if> <@boundingBoxWithRotation state data.rotationMode data.enablePitch/><#if data.rotationMode == 0>;</#if>
				}
				</#list>
				<#if data.rotationMode == 0>return</#if> <@boundingBoxWithRotation data data.rotationMode data.enablePitch/><#if data.rotationMode == 0>;</#if>
			});
		}

		private ImmutableMap<BlockState, VoxelShape> getShapeForEachState(Function<BlockState, VoxelShape> func) {
			return stateContainer.getValidStates().stream().collect(ImmutableMap.toImmutableMap(Function.identity(), func));
		}
		</#if>

		@Override public VoxelShape getShape(BlockState state, IBlockReader world, BlockPos pos, ISelectionContext context) {
			<#assign offset = !data.shouldDisableOffset() && !data.isBoundingBoxEmpty()>
			<#if offset>Vector3d offset = state.getOffset(world, pos);</#if>

			<#if data.rotationMode == 0 && !statesWithCustomShape?has_content><#-- shape not state dependent -->
			return SHAPE<#if offset>.withOffset(offset.x, offset.y, offset.z)</#if>;
			<#else><#-- shape is state dependent -->
			return shapes.get(state)<#if offset>.withOffset(offset.x, offset.y, offset.z)</#if>;
			</#if>
		}
	</#if>

	<#if data.renderType() == 4>
   	@Override public BlockRenderType getRenderType(BlockState state) {
		return BlockRenderType.INVISIBLE;
   	}
   	</#if>

	<#if data.blockBase?has_content && data.blockBase == "Stairs">
   	@Override public float getExplosionResistance() {
		return ${data.resistance}f;
   	}

   	@Override public boolean ticksRandomly(BlockState state) {
		return ${data.tickRandomly?c};
   	}
	</#if>

	<@addSpecialInformation data.specialInformation, "block." + modid + "." + registryname, true/>

	<#if data.displayFluidOverlay>
	@Override public boolean shouldDisplayFluidOverlay(BlockState state, IBlockDisplayReader world, BlockPos pos, FluidState fluidstate) {
		return true;
	}
	</#if>

	<#if data.beaconColorModifier?has_content>
	@Override public float[] getBeaconColorMultiplier(BlockState state, IWorldReader world, BlockPos pos, BlockPos beaconPos) {
		return new float[] { ${data.beaconColorModifier.getRed()/255}f, ${data.beaconColorModifier.getGreen()/255}f, ${data.beaconColorModifier.getBlue()/255}f };
	}
	</#if>

	<#if data.connectedSides>
	@Override public boolean isSideInvisible(BlockState state, BlockState adjacentBlockState, Direction side) {
		return adjacentBlockState.getBlock() == this ? true : super.isSideInvisible(state, adjacentBlockState, side);
	}
	</#if>

	<#if data.hasCustomOpacity>
		<#if (!data.blockBase?has_content || data.blockBase == "Leaves") && data.lightOpacity == 0>
		@Override public boolean propagatesSkylightDown(BlockState state, IBlockReader reader, BlockPos pos) {
			return <#if data.isWaterloggable>state.getFluidState().isEmpty()<#else>true</#if>;
		}
		</#if>

		<#if !data.blockBase?has_content || data.blockBase == "Leaves" || data.lightOpacity != 15>
		@Override public int getOpacity(BlockState state, IBlockReader worldIn, BlockPos pos) {
			<#if data.isWaterloggable && data.lightOpacity == 0> <#-- Prevent fully transparent blocks from overriding water opacity -->
				return propagatesSkylightDown(state, worldIn, pos) ? 0 : 1;
			<#else>
				return ${data.lightOpacity};
			</#if>
		}
		</#if>
	</#if>

	<#if data.hasTransparency && !data.blockBase?has_content>
	@Override public VoxelShape getRaytraceShape(BlockState state, IBlockReader world, BlockPos pos) {
		return VoxelShapes.empty();
	}
	</#if>

	<#if data.rotationMode != 0 || data.isWaterloggable || filteredCustomProperties?has_content>
	@Override protected void fillStateContainer(StateContainer.Builder<Block, BlockState> builder) {
		super.fillStateContainer(builder);
		<#assign props = []>
		<#if data.rotationMode == 5>
			<#assign props += ["AXIS"]>
		<#elseif data.rotationMode != 0>
			<#assign props += ["FACING"]>
			<#if (data.rotationMode == 1 || data.rotationMode == 3) && data.enablePitch>
				<#assign props += ["FACE"]>
			</#if>
		</#if>
		<#list filteredCustomProperties as prop>
			<#assign props += [prop.property().getName().replace("CUSTOM:", "")?upper_case]>
		</#list>
		<#if data.isWaterloggable>
			<#assign props += ["WATERLOGGED"]>
		</#if>
		builder.add(${props?join(", ")});
	}

	@Override public BlockState getStateForPlacement(BlockItemUseContext context) {
		<#if data.isWaterloggable>
		boolean flag = context.getWorld().getFluidState(context.getPos()).getFluid() == Fluids.WATER;
		</#if>
		<#if data.rotationMode != 3>
		return super.getStateForPlacement(context)
			<#if data.rotationMode == 1>
			    <#if data.enablePitch>
			    .with(FACE, faceForDirection(context.getNearestLookingDirection()))
			    </#if>
			.with(FACING, context.getPlacementHorizontalFacing().getOpposite())
			<#elseif data.rotationMode == 2>
			.with(FACING, context.getNearestLookingDirection().getOpposite())
			<#elseif data.rotationMode == 4>
			.with(FACING, context.getFace())
			<#elseif data.rotationMode == 5>
			.with(AXIS, context.getFace().getAxis())
			</#if>
	    	<@initCustomBlockStateProperties />
			<#if data.isWaterloggable>
			.with(WATERLOGGED, flag)
			</#if>;
		<#elseif data.rotationMode == 3>
	    if (context.getFace().getAxis() == Direction.Axis.Y)
	        return super.getStateForPlacement(context)
	    		<#if data.enablePitch>
	    		    .with(FACE, context.getFace().getOpposite() == Direction.UP ? AttachFace.CEILING : AttachFace.FLOOR)
	    		    .with(FACING, context.getPlacementHorizontalFacing())
	    		<#else>
	    		    .with(FACING, Direction.NORTH)
	    		</#if>
	    		<@initCustomBlockStateProperties />
	    		<#if data.isWaterloggable>
	    		.with(WATERLOGGED, flag)
	    		</#if>;

	    return super.getStateForPlacement(context)
	    	<#if data.enablePitch>
	    	    .with(FACE, AttachFace.WALL)
	    	</#if>
	    	.with(FACING, context.getFace())
	    	<@initCustomBlockStateProperties />
	    	<#if data.isWaterloggable>
	    	.with(WATERLOGGED, flag)
	    	</#if>;
		</#if>
	}
	</#if>

	<#macro initCustomBlockStateProperties>
		<#list filteredCustomProperties as prop>
			<#assign propName = prop.property().getName()>
			.with(${propName.replace("CUSTOM:", "")?upper_case},
				<#if prop.property().getClass().getSimpleName().equals("StringType")>
					<#if propName.startsWith("CUSTOM:")>
					${StringUtils.snakeToCamel(propName.replace("CUSTOM:", ""))}Property.${prop.value()?upper_case}
					<#else>
					${propName?upper_case}.getValue("${prop.value()}").get()
					</#if>
				<#else>
				${prop.value()}
				</#if>
			)
		</#list>
	</#macro>

	<#if data.rotationMode != 0>
		<#if data.rotationMode != 5>
		public BlockState rotate(BlockState state, Rotation rot) {
			return state.with(FACING, rot.rotate(state.get(FACING)));
		}

		public BlockState mirror(BlockState state, Mirror mirrorIn) {
			return state.rotate(mirrorIn.toRotation(state.get(FACING)));
		}
		<#else>
		@Override public BlockState rotate(BlockState state, Rotation rot) {
			if(rot == Rotation.CLOCKWISE_90 || rot == Rotation.COUNTERCLOCKWISE_90) {
				if (state.get(AXIS) == Direction.Axis.X) {
					return state.with(AXIS, Direction.Axis.Z);
				} else if (state.get(AXIS) == Direction.Axis.Z) {
					return state.with(AXIS, Direction.Axis.X);
				}
			}
			return state;
		}
		</#if>

		<#if data.rotationMode == 1 && data.enablePitch>
		private AttachFace faceForDirection(Direction direction) {
			if (direction.getAxis() == Direction.Axis.Y)
				return direction == Direction.UP ? AttachFace.CEILING : AttachFace.FLOOR;
			else
				return AttachFace.WALL;
		}
		</#if>
	</#if>

	<#if hasProcedure(data.placingCondition)>
	@Override public boolean isValidPosition(BlockState blockstate, IWorldReader worldIn, BlockPos pos) {
		if (worldIn instanceof IWorld) {
			IWorld world = (IWorld) worldIn;
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			return <@procedureOBJToConditionCode data.placingCondition/>;
		}
		return super.isValidPosition(blockstate, worldIn, pos);
	}
	</#if>

	<#if data.isWaterloggable>
	@Override public FluidState getFluidState(BlockState state) {
	    return state.get(WATERLOGGED) ? Fluids.WATER.getStillFluidState(false) : super.getFluidState(state);
	}
	</#if>

	<#if data.isWaterloggable || hasProcedure(data.placingCondition)>
	@Override public BlockState updatePostPlacement(BlockState state, Direction facing, BlockState facingState, IWorld world, BlockPos currentPos, BlockPos facingPos) {
	    <#if data.isWaterloggable>
		if (state.get(WATERLOGGED)) {
			world.getPendingFluidTicks().scheduleTick(currentPos, Fluids.WATER, Fluids.WATER.getTickRate(world));
		}
		</#if>
		return <#if hasProcedure(data.placingCondition)>
		!state.isValidPosition(world, currentPos) ? Blocks.AIR.getDefaultState() :
		</#if> super.updatePostPlacement(state, facing, facingState, world, currentPos, facingPos);
	}
	</#if>

	<#if data.enchantPowerBonus != 0>
	@Override public float getEnchantPowerBonus(BlockState state, IWorldReader world, BlockPos pos) {
		return ${data.enchantPowerBonus}f;
	}
	</#if>

	<#if data.isReplaceable>
	@Override public boolean isReplaceable(BlockState state, BlockItemUseContext context) {
		return context.getItem().getItem() != this.asItem();
	}
	</#if>

	<#if data.canProvidePower && data.emittedRedstonePower??>
	@Override public boolean canProvidePower(BlockState state) {
		return true;
	}

	@Override public int getWeakPower(BlockState blockstate, IBlockReader blockAccess, BlockPos pos, Direction direction) {
		<#if hasProcedure(data.emittedRedstonePower)>
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			World world = (World) blockAccess;
			return (int) <@procedureOBJToNumberCode data.emittedRedstonePower/>;
		<#else>
			return ${data.emittedRedstonePower.getFixedValue()};
		</#if>
	}
	</#if>

	<#if data.ignitedByLava>
	@Override public boolean isFlammable(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
	    return true;
	}
	</#if>

	<#if data.flammability != 0>
	@Override public int getFlammability(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.flammability};
	}
	</#if>

	<#if data.fireSpreadSpeed != 0>
	@Override public int getFireSpreadSpeed(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.fireSpreadSpeed};
	}
	</#if>

	<#if data.strippingResult?? && !data.strippingResult.isEmpty()>
	@Override public BlockState getToolModifiedState(BlockState blockstate, World world, BlockPos pos, PlayerEntity player, ItemStack stack, ToolType itemAbility) {
		if (ToolType.AXE == itemAbility) {
			return ${mappedBlockToBlock(data.strippingResult)}.getDefaultState().with(RotatedPillarBlock.AXIS, blockstate.get(RotatedPillarBlock.AXIS));
		}
		return super.getToolModifiedState(blockstate, world, pos, player, stack, itemAbility);
	}
	</#if>

	<#if data.creativePickItem?? && !data.creativePickItem.isEmpty()>
	@Override public ItemStack getPickBlock(BlockState state, RayTraceResult target, IBlockReader world, BlockPos pos, PlayerEntity player) {
		return ${mappedMCItemToItemStackCode(data.creativePickItem, 1)};
	}
	<#elseif !data.hasBlockItem && (data.blockBase! != "FlowerPot")>
	@Override public ItemStack getPickBlock(BlockState state, RayTraceResult target, IBlockReader world, BlockPos pos, PlayerEntity player) {
		return ItemStack.EMPTY;
	}
	</#if>

	<#if data.xpAmountMax != 0>
	@Override public int getExpDrop(BlockState state, IWorldReader level, BlockPos pos, int fortuneLevel, int silkTouchLevel) {
		<#if data.xpAmountMin == data.xpAmountMax>
		return ${data.xpAmountMin};
		<#else>
		return ((World) level).rand.nextInt(${data.xpAmountMax} - ${data.xpAmountMin} + 1) + ${data.xpAmountMin};
		</#if>
	}
	</#if>

	<#if generator.map(data.aiPathNodeType, "pathnodetypes") != "DEFAULT">
	@Override public PathNodeType getAiPathNodeType(BlockState state, IBlockReader world, BlockPos pos, MobEntity entity) {
		return PathNodeType.${generator.map(data.aiPathNodeType, "pathnodetypes")};
	}
	</#if>

	<#if data.offsetType != "NONE">
	@Override public Block.OffsetType getOffsetType() {
		return Block.OffsetType.${data.offsetType};
	}
	</#if>

	<#if data.plantsGrowOn>
	@Override public boolean canSustainPlant(BlockState state, IBlockReader world, BlockPos pos, Direction direction, IPlantable plantable) {
		return true;
	}
	</#if>

	<#if data.reactionToPushing != "NORMAL">
	@Override public PushReaction getPushReaction(BlockState state) {
		return PushReaction.${data.reactionToPushing};
	}
	</#if>

	<#if data.canRedstoneConnect>
	@Override public boolean canConnectRedstone(BlockState state, IBlockReader world, BlockPos pos, Direction side) {
		return true;
	}
	</#if>

	<#if hasProcedure(data.additionalHarvestCondition)>
	@Override public boolean canHarvestBlock(BlockState state, IBlockReader world, BlockPos pos, PlayerEntity player) {
		return super.canHarvestBlock(state, world, pos, player) && <@procedureCode data.additionalHarvestCondition, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"entity": "player",
			"world": "player.world",
			"blockstate": "state"
		}, false/>;
	}
	</#if>

	<@onBlockAdded data.onBlockAdded, hasProcedure(data.onTickUpdate) && data.shouldScheduleTick(), data.tickRate/>

	<@onRedstoneOrNeighborChanged data.onRedstoneOn, data.onRedstoneOff, data.onNeighbourBlockChanges/>

	<#if hasProcedure(data.onTickUpdate)>
	@Override public void <#if data.tickRandomly && (data.blockBase?has_content && data.blockBase == "Stairs")>randomTick<#else>tick</#if>
		(BlockState blockstate, ServerWorld world, BlockPos pos, Random random) {
		super.<#if data.tickRandomly && (data.blockBase?has_content && data.blockBase == "Stairs")>randomTick<#else>tick</#if>(blockstate, world, pos, random);
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();

		<@procedureOBJToCode data.onTickUpdate/>

		<#if data.shouldScheduleTick()>
		world.getPendingBlockTicks().scheduleTick(pos, this, ${data.tickRate});
		</#if>
	}
	</#if>

	<@onAnimateTick data.onRandomUpdateEvent/>

	<@onDestroyedByPlayer data.onDestroyedByPlayer/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>

	<@onStartToDestroy data.onStartToDestroy/>

	<@onEntityCollides data.onEntityCollides/>

	<@onEntityWalksOn data.onEntityWalksOn/>

	<@onEntityFallsOn data.onEntityFallsOn/>

	<@onHitByProjectile data.onHitByProjectile/>

	<@onBlockPlacedBy data.onBlockPlayedBy/>

	<#if hasProcedure(data.onRightClicked) || data.shouldOpenGUIOnRightClick()>
	@Override public ActionResultType onBlockActivated(BlockState blockstate, World world, BlockPos pos, PlayerEntity entity, Hand hand, BlockRayTraceResult hit) {
		super.onBlockActivated(blockstate, world, pos, entity, hand, hit);
		<#if data.shouldOpenGUIOnRightClick()>
		if(entity instanceof ServerPlayerEntity) {
			NetworkHooks.openGui(((ServerPlayerEntity) entity), new INamedContainerProvider() {
				@Override public ITextComponent getDisplayName() {
					return new StringTextComponent("${data.name}");
				}
				@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
					return new ${data.guiBoundTo}Menu(id, inventory, new PacketBuffer(Unpooled.buffer()).writeBlockPos(pos));
				}
			}, pos);
		}
		</#if>

		<#if hasProcedure(data.onRightClicked)>
			int x = pos.getX();
			int y = pos.getY();
			int z = pos.getZ();
			double hitX = hit.getHitVec().x;
			double hitY = hit.getHitVec().y;
			double hitZ = hit.getHitVec().z;
			Direction direction = hit.getFace();
			<#if hasReturnValueOf(data.onRightClicked, "actionresulttype")>
			ActionResultType result = <@procedureOBJToInteractionResultCode data.onRightClicked/>;
			<#else>
			<@procedureOBJToCode data.onRightClicked/>
			</#if>
		</#if>

		<#if data.shouldOpenGUIOnRightClick() || !hasReturnValueOf(data.onRightClicked, "actionresulttype")>
		return ActionResultType.SUCCESS;
		<#else>
		return result;
		</#if>
	}
	</#if>

	<#if data.isBonemealable && !(data.blockBase?has_content && data.blockBase == "TrapDoor")>
	<@bonemealEvents data.isBonemealTargetCondition, data.bonemealSuccessCondition, data.onBonemealSuccess/>
	</#if>

	<#if data.hasInventory>
		@Override public INamedContainerProvider getContainer(BlockState state, World worldIn, BlockPos pos) {
			TileEntity tileEntity = worldIn.getTileEntity(pos);
			return tileEntity instanceof INamedContainerProvider ? ((INamedContainerProvider) tileEntity) : null;
		}

		@Override public boolean hasTileEntity(BlockState state) {
			return true;
		}

		@Override public TileEntity createTileEntity(BlockState state, IBlockReader world) {
		    return new ${name}BlockEntity();
		}

	    @Override
		public boolean eventReceived(BlockState state, World world, BlockPos pos, int eventID, int eventParam) {
			super.eventReceived(state, world, pos, eventID, eventParam);
			TileEntity blockEntity = world.getTileEntity(pos);
			return blockEntity != null && blockEntity.receiveClientEvent(eventID, eventParam);
		}

	    <#if data.inventoryDropWhenDestroyed>
		@Override public void onReplaced(BlockState state, World world, BlockPos pos, BlockState newState, boolean isMoving) {
			if (state.getBlock() != newState.getBlock()) {
				TileEntity blockEntity = world.getTileEntity(pos);
				if (blockEntity instanceof ${name}BlockEntity) {
					InventoryHelper.dropInventoryItems(world, pos, ((${name}BlockEntity) blockEntity));
					world.updateComparatorOutputLevel(pos, this);
				}

				super.onReplaced(state, world, pos, newState, isMoving);
			}
		}
	    </#if>

	    <#if data.inventoryComparatorPower>
	    @Override public boolean hasComparatorInputOverride(BlockState state) {
			return true;
		}

	    @Override public int getComparatorInputOverride(BlockState blockState, World world, BlockPos pos) {
			TileEntity tileentity = world.getTileEntity(pos);
			if (tileentity instanceof ${name}BlockEntity)
				return Container.calcRedstoneFromInventory(((${name}BlockEntity) tileentity));
			else
				return 0;
		}
	    </#if>
	</#if>

	<#if data.tintType != "No tint">
		@OnlyIn(Dist.CLIENT) public static void blockColorLoad(ColorHandlerEvent.Block event) {
			event.getBlockColors().register((bs, world, pos, index) -> {
				<#if data.tintType == "Default foliage">
					return FoliageColors.getDefault();
				<#elseif data.tintType == "Birch foliage">
					return FoliageColors.getBirch();
				<#elseif data.tintType == "Spruce foliage">
					return FoliageColors.getSpruce();
				<#else>
					return world != null && pos != null ?
					<#if data.tintType == "Grass">
						BiomeColors.getGrassColor(world, pos) : GrassColors.get(0.5D, 1.0D);
					<#elseif data.tintType == "Foliage">
						BiomeColors.getFoliageColor(world, pos) : FoliageColors.getDefault();
					<#elseif data.tintType == "Water">
						BiomeColors.getWaterColor(world, pos) : -1;
					<#elseif data.tintType == "Sky">
						Minecraft.getInstance().world.getBiome(pos).getSkyColor() : 8562943;
					<#elseif data.tintType == "Fog">
						Minecraft.getInstance().world.getBiome(pos).getFogColor() : 12638463;
					<#else>
						Minecraft.getInstance().world.getBiome(pos).getWaterFogColor() : 329011;
					</#if>
				</#if>
			}, ${JavaModName}Blocks.${REGISTRYNAME}.get());
		}

		<#if data.isItemTinted && data.hasBlockItem>
		@OnlyIn(Dist.CLIENT) public static void itemColorLoad(ColorHandlerEvent.Item event) {
			event.getItemColors().register((stack, index) -> {
				<#if data.tintType == "Grass">
					return GrassColors.get(0.5D, 1.0D);
				<#elseif data.tintType == "Foliage" || data.tintType == "Default foliage">
					return FoliageColors.getDefault();
				<#elseif data.tintType == "Birch foliage">
					return FoliageColors.getBirch();
				<#elseif data.tintType == "Spruce foliage">
					return FoliageColors.getSpruce();
				<#elseif data.tintType == "Water">
					return 3694022;
				<#elseif data.tintType == "Sky">
					return 8562943;
				<#elseif data.tintType == "Fog">
					return 12638463;
				<#else>
					return 329011;
				</#if>
			}, ${JavaModName}Blocks.${REGISTRYNAME}.get());
		}
		</#if>
	</#if>

	<#list data.customProperties as prop>
		<#if prop.property().getName().startsWith("CUSTOM:") && prop.property().getClass().getSimpleName().equals("StringType")>
		<#assign propClassName = StringUtils.snakeToCamel(prop.property().getName().replace("CUSTOM:", ""))>
		public enum ${propClassName}Property implements IStringSerializable {
			<#list prop.property.getArrayData() as value>
			${value?upper_case}("${value}")<#sep>,
			</#list>;
			private final String name;
			private ${propClassName}Property(String name) {
				this.name = name;
			}
			@Override public String getString() {
				return this.name;
			}

			@Override public String toString() {
				return this.name;
			}
		}
		</#if>
	</#list>
}
</@javacompress>
<#-- @formatter:on -->

<#function getClassName>
	<#if var_extends_class! == "WallSignBlock"><#return data.getWallName()>
	<#else><#return name>
	</#if>
</#function>

<#function getBlockClass blockBase="">
	<#if var_extends_class??><#return var_extends_class>
	<#elseif data.hasGravity><#return "FallingBlock">
	<#elseif blockBase == "Button">
		<#if blockSetType != "NETHER_WOOD">
            <#return "net.minecraft.block.StoneButtonBlock">
        <#else>
            <#return "net.minecraft.block.WoodButtonBlock">
        </#if>
	<#elseif blockBase == "Sign" || blockBase == "HangingSign"><#return "StandingSignBlock">
	<#else><#return blockBase + "Block">
	</#if>
</#function>