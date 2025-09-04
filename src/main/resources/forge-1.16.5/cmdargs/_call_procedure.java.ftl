<#include "procedures.java.ftl">
.executes(arguments -> {
    World world = arguments.getSource().getWorld();

    double x = arguments.getSource().getPos().getX();
    double y = arguments.getSource().getPos().getY();
    double z = arguments.getSource().getPos().getZ();

    Entity entity = arguments.getSource().getEntity();
    if (entity == null && world instanceof ServerWorld)
        entity = FakePlayerFactory.getMinecraft((ServerWorld) world);

    Direction direction = Direction.DOWN;
    if (entity != null)
    	direction = entity.getHorizontalFacing();

    <@procedureToCode name=procedure dependencies=dependencies/>
    return 0;
})
