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

public class ${name}Screen extends ContainerScreen<${name}Menu> {

	private final static HashMap<String, Object> guistate = ${name}Menu.guistate;

	private final World world;
	private final int x, y, z;
	private final PlayerEntity entity;

	<#list data.getComponentsOfType("TextField") as component>
	TextFieldWidget ${component.getName()};
	</#list>

	<#list data.getComponentsOfType("Checkbox") as component>
	CheckboxButton ${component.getName()};
	</#list>

	<#list data.getComponentsOfType("Button") as component>
	Button ${component.getName()};
	</#list>

	<#list data.getComponentsOfType("ImageButton") as component>
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

	<#if data.doesPauseGame>
		@Override public boolean isPauseScreen() {
			return true;
		}
	</#if>

	<#if data.renderBgLayer>
		private static final ResourceLocation texture = new ResourceLocation("${modid}:textures/screens/${registryname}.png" );
	</#if>

	@Override public void render(MatrixStack ms, int mouseX, int mouseY, float partialTicks) {
		this.renderBackground(ms);
		super.render(ms, mouseX, mouseY, partialTicks);

		<#list data.getComponentsOfType("TextField") as component>
				${component.getName()}.render(ms, mouseX, mouseY, partialTicks);
		</#list>

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
					<#if followMouse>(float) Math.atan((this.guiTop + ${y + 21 - 50} - mouseY) / 40.0)<#else>0</#if>,
					(LivingEntity) <@procedureOBJToConditionCode component.entityModel/>
				);
			}
		</#list>

		this.renderHoveredTooltip(ms, mouseX, mouseY);

		<#list data.getComponentsOfType("Tooltip") as component>
			<#assign x = component.gx(data.width)>
			<#assign y = component.gy(data.height)>
			<#if hasProcedure(component.displayCondition)>
				if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
				if (mouseX > guiLeft + ${x} && mouseX < guiLeft + ${x + component.width} && mouseY > guiTop + ${y} && mouseY < guiTop + ${y + component.height})
					this.renderTooltip(ms, <#if hasProcedure(component.text)>new StringTextComponent(<@procedureOBJToStringCode component.text/>)<#else>new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}")</#if>, mouseX, mouseY);
		</#list>
	}

	@Override protected void drawGuiContainerBackgroundLayer(MatrixStack ms, float partialTicks, int gx, int gy) {
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

		<#list data.getComponentsOfType("TextField") as component>
			if(${component.getName()}.isFocused())
				return ${component.getName()}.keyPressed(key, b, c);
		</#list>

		return super.keyPressed(key, b, c);
	}

	<#if data.getComponentsOfType("TextField")?has_content>
	@Override public void tick() {
		super.tick();
		<#list data.getComponentsOfType("TextField") as component>
		${component.getName()}.tick();
		</#list>
	}

	@Override public void resize(Minecraft minecraft, int width, int height) {
		<#list data.getComponentsOfType("TextField") as component>
		String ${component.getName()}Value = ${component.getName()}.getText();
		</#list>
		super.resize(minecraft, width, height);
		<#list data.getComponentsOfType("TextField") as component>
		${component.getName()}.setText(${component.getName()}Value);
		</#list>
	}
	</#if>

	@Override protected void drawGuiContainerForegroundLayer(MatrixStack poseStack, int mouseX, int mouseY) {
		<#list data.getComponentsOfType("Label") as component>
			<#if hasProcedure(component.displayCondition)>
				if (<@procedureOBJToConditionCode component.displayCondition/>)
			</#if>
			this.font.drawString(poseStack,
				<#if hasProcedure(component.text)><@procedureOBJToStringCode component.text/><#else>new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString()</#if>,
				${component.gx(data.width)}, ${component.gy(data.height)}, ${component.color.getRGB()});
		</#list>
	}

	@Override public void init(Minecraft minecraft, int width, int height) {
		super.init(minecraft, width, height);

		<#list data.getComponentsOfType("TextField") as component>
			${component.getName()} = new TextFieldWidget(this.font, this.guiLeft + ${component.gx(data.width) + 1}, this.guiTop + ${component.gy(data.height) + 1},
			${component.width - 2}, ${component.height - 2}, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"))
			<#if component.placeholder?has_content>
			{
				@Override public void writeText(String text) {
					super.writeText(text);
					if (getText().isEmpty())
						setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
					else
						setSuggestion(null);
				}

				@Override public void setCursorPosition(int pos) {
					super.setCursorPosition(pos);
					if (getText().isEmpty())
						setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
					else
						setSuggestion(null);
				}
			}
			</#if>;
			<#if component.placeholder?has_content>
			${component.getName()}.setSuggestion(new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}").getString());
			</#if>
			${component.getName()}.setMaxStringLength(32767);

			guistate.put("text:${component.getName()}", ${component.getName()});
			this.children.add(this.${component.getName()});
		</#list>

		<#assign btid = 0>

		<#list data.getComponentsOfType("Button") as component>
			${component.getName()} = new Button(
				this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
				${component.width}, ${component.height},
				new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"),
				<@buttonOnClick component/>
			)<@buttonDisplayCondition component/>;

			guistate.put("button:${component.getName()}", ${component.getName()});
			this.addButton(${component.getName()});

			<#assign btid +=1>
		</#list>

		<#list data.getComponentsOfType("ImageButton") as component>
		    ${component.getName()} = new ImageButton(
				this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
            	${component.getWidth(w.getWorkspace())}, ${component.getHeight(w.getWorkspace())},
				0, 0, ${component.getHeight(w.getWorkspace())},
            	new ResourceLocation("${modid}:textures/screens/atlas/${component.getName()}.png"),
            	${component.getWidth(w.getWorkspace())},
				${component.getHeight(w.getWorkspace()) * 2},
				<@buttonOnClick component/>
			)<@buttonDisplayCondition component/>;

			guistate.put("button:${component.getName()}", ${component.getName()});
			this.addButton(${component.getName()});

			<#assign btid +=1>
		</#list>

		<#list data.getComponentsOfType("Checkbox") as component>
			${component.getName()} = new CheckboxButton(this.guiLeft + ${component.gx(data.width)}, this.guiTop + ${component.gy(data.height)},
					20, 20, new TranslationTextComponent("gui.${modid}.${registryname}.${component.getName()}"), <#if hasProcedure(component.isCheckedProcedure)>
				<@procedureOBJToConditionCode component.isCheckedProcedure/><#else>false</#if>);

			guistate.put("checkbox:${component.getName()}", ${component.getName()});
			this.addButton(${component.getName()});
		</#list>
	}
}
<#macro buttonOnClick component>
e -> {
    <#if hasProcedure(component.onClick)>
	    if (<@procedureOBJToConditionCode component.displayCondition/>) {
			${JavaModName}.PACKET_HANDLER.sendToServer(new ${name}ButtonMessage(${btid}, x, y, z));
			${name}ButtonMessage.handleButtonAction(entity, ${btid}, x, y, z);
		}
	</#if>
}
</#macro>
<#macro buttonDisplayCondition component>
<#if hasProcedure(component.displayCondition)>
{
	@Override public void renderButton(MatrixStack ms, int gx, int gy, float ticks) {
		this.visible = <@procedureOBJToConditionCode component.displayCondition/>;
		super.renderButton(ms, gx, gy, ticks);
	}
}
</#if>
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
