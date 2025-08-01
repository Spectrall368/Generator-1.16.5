<#include "procedures.java.ftl">
.executes(arguments -> {
    World world = arguments.getSource().getLevel();

    double x = arguments.getSource().getPosition().x();
    double y = arguments.getSource().getPosition().y();
    double z = arguments.getSource().getPosition().z();

    Entity entity = arguments.getSource().getEntity();
    if (entity == null && world instanceof ServerWorld)
        entity = FakePlayerFactory.getMinecraft((ServerWorld) world);

    Direction direction = Direction.DOWN;
    if (entity != null)
    	direction = entity.getDirection();

    <@procedureToCode name=procedure dependencies=dependencies/>
    return 0;
})