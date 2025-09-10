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
<#include "../procedures.java.ftl">
package ${package}.client.gui;

<#assign textFields = data.getComponentsOfType("TextField")>
<#assign checkboxes = data.getComponentsOfType("Checkbox")>
<#assign buttons = data.getComponentsOfType("Button")>
<#assign imageButtons = data.getComponentsOfType("ImageButton")>
<#assign tooltips = data.getComponentsOfType("Tooltip")>

<#compress>
public class ${name}Screen extends ContainerScreen<${name}Menu> implements ${JavaModName}Screens.ScreenAccessor {

	private final World world;
	private final int x, y, z;
	private final PlayerEntity entity;

	private boolean menuStateUpdateActive = false;

	<#list textFields as component>
	TextFieldWidget ${component.getName()};
	</#list>

	<#list checkboxes as component>
	CheckboxButton ${component.getName()};
	</#list>

	<#list buttons as component>
	Button ${component.getName()};
	</#list>

	<#list imageButtons as component>
	ImageButton ${component.getName()};
	</#list>

	public ${name}Screen(${name}Menu container, PlayerInventory inventory, ITextComponent text) {
		super(container, inventory, text);
		this.world = container.world;
		this.x = container.x;
		this.y = container.y;
		this.z = container.z;
		this.entity = container.entity;
		this.xSize = ${data.width};
		this.ySize = ${data.height};
	}

	@Override public void updateMenuState(int elementType, String name, Object elementState) {
		menuStateUpdateActive = true;

		<#if textFields?has_content>
		if (elementType == 0 && elementState instanceof String) {
			<#list textFields as component>
				<#if !component?is_first>else</#if> if (name.equals("${component.getName()}"))
					${component.getName()}.setText((String) elementState);
			</#list>
		}
		</#if>

		<#-- updateMenuState is not implemented for checkboxes, as there is no procedure block to set checkbox state currently -->

		menuStateUpdateActive = false;
	}

	<#if data.doesPauseGame>
	@Override public boolean isPauseScreen() {
		return true;
	}
	</#if>

	<#if data.renderBgLayer>
	private static final ResourceLocation texture = new ResourceLocation("${modid}:textures/screens/${registryname}.png");
	</#if>

	@Override public void render(MatrixStack ms, int mouseX, int mouseY, float partialTicks) {
		this.renderBackground(ms);
		super.render(ms, mouseX, mouseY, partialTicks);

		<#list textFields as component>
		${component.getName()}.render(ms, mouseX, mouseY, partialTicks);
		</#list>

		<#compress>
		<#list data.getComponentsOfType("EntityModel") as component>
			<#assign followMouse = component.followMouseMovement>
			<#assign x = component.gx(data.width)>
			<#assign y = component.gy(data.height)>
			if (<@procedureOBJToConditionCode component.entityModel/> instanceof LivingEntity) {
				<#if hasProcedure(component.displayCondition)>
					if (<@procedureOBJToConditionCode component.displayCondition/>)
				</#if>
				InventoryScreen.drawEntityOnScreen(this.guiLeft + ${x + 10}, this.guiTop + ${y + 20}, ${component.scale},
					${component.rotationX / 20.0}f <#if followMouse> + (float) Math.atan((this.guiLeft + ${x + 10} - mouseX) / 40.0)</#if>,
					<#if followMouse>(float) Math.atan((this.guiTop + ${y + 21 - 50} - mouseY) / 40.0)<#else>0</#if>, (LivingEntity) <@procedureOBJToConditionCode component.entityModel/>);
			}
		</#list>
		</#compress>

		<#if tooltips?has_content>
		boolean customTooltipShown = false;
		</#if>
		<#list tooltips as component>
			<#assign x = component.gx(data.width)>
			<#assign y = component.gy(data.height)>
			<#if hasProcedure(component.displayCondition)>
				if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
				if (mouseX > guiLeft + ${x} && mouseX < guiLeft + ${x + component.width} && mouseY > guiTop + ${y} && mouseY < guiTop + ${y + component.height}) {
					<#if hasProcedure(component.text)>
					String hoverText = <@procedureOBJToStringCode component.text/>;
					if (hoverText != null) {
						this.func_243308_b(ms, Arrays.stream(hoverText.split("\n")).map(StringTextComponent::new).collect(Collectors.toList()), mouseX, mouseY);
					}
					<#else>
						this.renderTooltip(ms, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"), mouseX, mouseY);
					</#if>
					customTooltipShown = true;
				}
		</#list>

		<#if tooltips?has_content>
		if (!customTooltipShown)
		</#if>
		this.renderHoveredTooltip(ms, mouseX, mouseY);
	}

	@Override protected void drawGuiContainerBackgroundLayer(MatrixStack ms, float partialTicks, int mouseX, int mouseY) {
		RenderSystem.color4f(1, 1, 1, 1);
		RenderSystem.enableBlend();
		RenderSystem.defaultBlendFunc();

		<#if data.renderBgLayer>
			Minecraft.getInstance().getTextureManager().bindTexture(texture);
			this.blit(ms, this.guiLeft, this.guiTop, 0, 0, this.xSize, this.ySize, this.xSize, this.ySize);
		</#if>

		<#list data.getComponentsOfType("Image") as component>
			<#if hasProcedure(component.displayCondition)>if (<@procedureOBJToConditionCode component.displayCondition/>) {</#if>
				Minecraft.getInstance().getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.image}"));
					this.blit(ms, this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)}, 0, 0,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>}</#if>
		</#list>

		<#list data.getComponentsOfType("Sprite") as component>
			<#if hasProcedure(component.displayCondition)>if (<@procedureOBJToConditionCode component.displayCondition/>) {</#if>
				Minecraft.getInstance().getTextureManager().bindTexture(new ResourceLocation("${modid}:textures/screens/${component.sprite}"));
					this.blit(ms, this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
					<#if (component.getTextureWidth(w.getWorkspace()) > component.getTextureHeight(w.getWorkspace()))>
						<@getSpriteByIndex component "width"/>, 0
					<#else>
						0, <@getSpriteByIndex component "height"/>
					</#if>,
					${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
					${component.getTextureWidth(w.getWorkspace())}, ${component.getTextureHeight(w.getWorkspace())});
			<#if hasProcedure(component.displayCondition)>}</#if>
		</#list>

		RenderSystem.disableBlend();
	}

	@Override public boolean keyPressed(int key, int b, int c) {
		if (key == 256) {
			this.minecraft.player.closeScreen();
			return true;
		}

		<#list textFields as component>
			if(${component.getName()}.isFocused())
				return ${component.getName()}.keyPressed(key, b, c);
		</#list>

		return super.keyPressed(key, b, c);
	}

	<#if textFields?has_content>
	@Override public void resize(Minecraft minecraft, int width, int height) {
		<#list textFields as component>
		String ${component.getName()}Value = ${component.getName()}.getText();
		</#list>
		super.resize(minecraft, width, height);
		<#list textFields as component>
		${component.getName()}.setText(${component.getName()}Value);
		</#list>
	}
	</#if>

	@Override protected void drawGuiContainerForegroundLayer(MatrixStack ms, int mouseX, int mouseY) {
		<#list data.getComponentsOfType("Label") as component>
			<#if hasProcedure(component.displayCondition)>
				if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
			this.font.func_243248_b(ms,
				<#if hasProcedure(component.text)>new StringTextComponent(<@procedureOBJToStringCode component.text/>)<#else>new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}")</#if>,
				${component.gx(data.width)}, ${component.gy(data.height)}, ${component.color.getRGB()});
		</#list>
	}

	@Override public void init(Minecraft minecraft, int width, int height) {
		super.init(minecraft, width, height);

		<#list textFields as component>
			${component.getName()} = new TextFieldWidget(this.font, this.guiLeft + ${component.gx(data.width) + 1}, this.guiTop + ${component.gy(data.height) + 1},
			${component.width - 2}, ${component.height - 2}, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"));
			${component.getName()}.setMaxStringLength(8192);
			${component.getName()}.setResponder(content -> {
				if (!menuStateUpdateActive)
					container.sendMenuStateUpdate(entity, 0, "${component.getName()}", content, false);
			});
			<#if component.placeholder?has_content>
			${component.getName()}.setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
			</#if>

			this.addListener(this.${component.getName()});
		</#list>

		<#assign btid = 0>

		<#list buttons as component>
			${component.getName()} = new Button(
				this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
				${component.width}, ${component.height},
				new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"),
				<@buttonOnClick component/>)<#if component.isUndecorated>{
                    @Override public void renderButton(MatrixStack ms, int mouseX, int mouseY, float partialTick) {
                        String text = this.isHovered() ? (TextFormatting.UNDERLINE + ${component.getName()}.getMessage().getString()) : ${component.getName()}.getMessage().getString();
                        drawString(ms, font, text, ${component.getName()}.x, ${component.getName()}.y, 16777215 | MathHelper.ceil(this.alpha * 255.0F) << 24);
                    }
                }</#if>;

			this.addButton(${component.getName()});

			<#assign btid +=1>
		</#list>

		<#list imageButtons as component>
			${component.getName()} = new ImageButton(
				this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
				${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
				0, 0, ${component.getHeight(w.getWorkspace())},
				new ResourceLocation("${modid}:textures/screens/atlas/${component.getName()}.png"),
				${component.getWidth(w.getWorkspace())},
				${component.getHeight(w.getWorkspace()) * 2},
				<@buttonOnClick component/>);

			this.addButton(${component.getName()});

			<#assign btid +=1>
		</#list>

		<#list checkboxes as component>
			<#if hasProcedure(component.isCheckedProcedure)>boolean ${component.getName()}Selected = <@procedureOBJToConditionCode component.isCheckedProcedure/>;</#if>
			${component.getName()} = new CheckboxButton(this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
				20, 20, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"),
				<#if hasProcedure(component.isCheckedProcedure)>${component.getName()}Selected<#else>false</#if>) {
				    @Override public void onPress() {
				        super.onPress();
				        if (!menuStateUpdateActive)
				            container.sendMenuStateUpdate(entity, 1, "${component.getName()}", this.isChecked(), false);
				    }
			};
			<#if hasProcedure(component.isCheckedProcedure)>
				if (${component.getName()}Selected)
					container.sendMenuStateUpdate(entity, 1, "${component.getName()}", true, false);
			</#if>

			this.addButton(${component.getName()});
		</#list>
	}

	<#if buttons?filter(component -> hasProcedure(component.displayCondition))?size != 0 || imageButtons?filter(component -> hasProcedure(component.displayCondition))?size != 0 || textFields?has_content>
	@Override public void tick() {
		super.tick();

		<#list textFields as component>
			${component.getName()}.tick();
		</#list>
		<#list buttons as component>
			<#if hasProcedure(component.displayCondition)>
				this.${component.getName()}.visible = <@procedureOBJToConditionCode component.displayCondition/>;
			</#if>
		</#list>
		<#list imageButtons as component>
			<#if hasProcedure(component.displayCondition)>
				this.${component.getName()}.visible = <@procedureOBJToConditionCode component.displayCondition/>;
			</#if>
		</#list>
	}
	</#if>

}
</#compress>

<#macro buttonOnClick component>
e -> {
	<#if hasProcedure(component.onClick)>
		int x = ${name}Screen.this.x; <#-- #5582 - x and y provided by buttons are in-GUI, not in-world coordinates -->
		int y = ${name}Screen.this.y;
		if (<@procedureOBJToConditionCode component.displayCondition/>) {
			${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}ButtonMessage(${btid}, x, y, z));
			${name}ButtonMessage.handleButtonAction(entity, ${btid}, x, y, z);
		}
	</#if>
}
</#macro>

<#macro getSpriteByIndex component dim>
	<#if hasProcedure(component.spriteIndex)>
		MathHelper.clamp((int) <@procedureOBJToNumberCode component.spriteIndex/> *
			<#if dim == "width">
				${component.getWidth(w.getWorkspace())}
			<#else>
				${component.getHeight(w.getWorkspace())}
			</#if>,
			0,
			<#if dim == "width">
				${component.getTextureWidth(w.getWorkspace()) - component.getWidth(w.getWorkspace())}
			<#else>
				${component.getTextureHeight(w.getWorkspace()) - component.getHeight(w.getWorkspace())}
			</#if>
		)
	<#else>
		<#if dim == "width">
			${component.getWidth(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		<#else>
			${component.getHeight(w.getWorkspace()) * component.spriteIndex.getFixedValue()}
		</#if>
	</#if>
</#macro>
<#-- @formatter:on -->
