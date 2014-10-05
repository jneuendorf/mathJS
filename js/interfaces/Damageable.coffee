###*
 * An Interface that specifies methods for damage interaction. Will be included as mixin.
 *
 * @class Damageable
 * @namespace ITF
*###
class TD.ITF.Damageable
	###*
	 * There can be no default implementation because when "enough damage was taken" it's uncertain whom to notify.
	 * 
	 * @method takeDamage
	 * @param {Number} damage
	 * @return {Damageable} This instance.
	 * 
	*###
	takeDamage: (damage) ->
		throw new Error("Needs to be implemented!")

	###*
	 * This is a default implementation for an interface method.
	 * 
	 * @method dealDamageTo
	 * @param {Damageable} damageable
	 * @param {Number} damage
	 * @return {Damageable} This instance.
	 * 
	*###
	dealDamageTo: (damageable, damage) ->
		damageable?.takeDamage?(damage)
		return @
