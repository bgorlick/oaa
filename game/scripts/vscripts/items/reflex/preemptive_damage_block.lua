-- defines item_preemptive_2b
-- defines item_preemptive_3b
-- defines modifier_item_preemptive_damage_reduction
LinkLuaModifier( "modifier_item_preemptive_damage_reduction", "items/reflex/preemptive_damage_block.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_bonus", "modifiers/modifier_generic_bonus.lua", LUA_MODIFIER_MOTION_NONE )

require('libraries/timers')

------------------------------------------------------------------------

item_preemptive_2b = class({})

function item_preemptive_2b:GetIntrinsicModifierName()
  return 'modifier_generic_bonus'
end

function item_preemptive_2b:OnSpellStart()
  local caster = self:GetCaster()
  local duration = self:GetSpecialValueFor("duration")
  local damageToHealPercent = self:GetSpecialValueFor("damage_as_healing")
  local spell = self

  -- for damage-to-heal
  spell.damageTaken = 0
  local modifier caster:AddNewModifier(caster, spell, 'modifier_item_preemptive_damage_reduction', {
    duration = duration
  })

  Timers:CreateTimer(duration, function ()
    local amountToHeal = spell.damageTaken * damageToHealPercent / 100
    caster:Heal(amountToHeal, spell)
  end)

  return true
end

function item_preemptive_2b:GetCooldown( nLevel )
  return self:GetSpecialValueFor( "cooldown" )
end

function item_preemptive_2b:ProcsMagicStick ()
  return false
end

item_preemptive_3b = item_preemptive_2b

------------------------------------------------------------------------

modifier_item_preemptive_damage_reduction = class({})

function modifier_item_preemptive_damage_reduction:IsHidden()
  return false
end

function modifier_item_preemptive_damage_reduction:IsDebuff()
  return false
end

function modifier_item_preemptive_damage_reduction:IsPurgable()
  return false
end

function modifier_item_preemptive_damage_reduction:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
  }
end

function modifier_item_preemptive_damage_reduction:GetModifierIncomingDamage_Percentage (event)
  --[[
    % reduction!
    process_procs: true
    order_type: 0
    issuer_player_index: 1177213984
    target: table: 0x006df7a0
    damage_category: 1
    reincarnate: false
    damage: 6.9628648757935
    ignore_invis: false
    attacker: table: 0x00537470
    ranged_attack": false
    record: 12
    do_not_consume: false
    damage_type: 1
    activity: -1
    heart_regen_applied: false
    diffusal_applied: false
    distance: 0
    no_attack_cooldown: false
    damage_flags: 0
    original_damage: 10
    cost: 0
    gain: 0
    basher_tested: false
    fail_type: 0
  ]]
  local spell = self:GetAbility()

  spell.damageTaken = spell.damageTaken + event.damage

  return spell:GetSpecialValueFor( "damage_reduction" ) * -1
end
