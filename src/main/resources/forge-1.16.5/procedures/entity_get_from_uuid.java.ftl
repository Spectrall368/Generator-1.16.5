<@addTemplate file="utils/entity/entity_from_uuid.java.ftl"/>
(world instanceof ServerWorld ? getEntityFromUUID((ServerWorld) world, ${input$uuid}) : null)