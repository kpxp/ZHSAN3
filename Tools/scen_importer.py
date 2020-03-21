import json

file_name = '194QXGJ-qh'
with open('CommonData.json', mode='r', encoding='utf-8') as cfin: 
	common = json.loads(cfin.read(), strict=False)
	with open(file_name + '.json', mode='r', encoding='utf-8') as fin:
		obj = json.loads(fin.read(), strict=False)
		
		with open(file_name + '/TerrainDetails.json', mode='w', encoding='utf-8') as fout:
			r = []
			for i in common['AllTerrainDetails']['TerrainDetails']:
				k = i['Value']
				r.append({
					"_Id": k['ID'],
					"Name": k['Name'],
					"TerrainIds": [k['ID']]
				})
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
		
		"""
		movement_to_save = [] 
		movement_set = {}
		movement_mapping = {}
		with open(file_name + '/MovementKinds.json', mode='w', encoding='utf-8') as fout:
			r = []
			for i in common['AllMilitaryKinds']['MilitaryKinds']:
				k = i['Value']
				costs = {
					"_Id": k['ID'],
					"MovementCosts": {
						1: k['PlainAdaptability'],
						2: k['GrasslandAdaptability'],
						3: k['ForrestAdaptability'],
						4: k['MarshAdaptability'],
						5: k['MountainAdaptability'],
						6: k['WaterAdaptability'],
						7: k['RidgeAdaptability'],
						8: k['WastelandAdaptability'],
						9: k['DesertAdaptability'],
						10: k['CliffAdaptability']
					}
				}
				cost_key = frozenset(costs['MovementCosts'].items())
				if cost_key in movement_set.keys():
					movement_mapping[k['ID']].append(movement_set[cost_key])
				else:
					movement_set[cost_key] = costs['_Id']
					movement_mapping[k['ID']] = [costs['_Id']]
					movement_to_save.append(costs)
			fout.write(json.dumps(movement_to_save, indent=2, ensure_ascii=False, sort_keys=True))
		"""
		with open(file_name + '/MilitaryKinds.json', mode='w', encoding='utf-8') as fout:
			r = []
			for i in common['AllMilitaryKinds']['MilitaryKinds']:
				k = i['Value']
				r.append({
					"_Id": k['ID'],
					"Name": k['Name'],
					"Offence": k['OffencePerScale'],
					"Defence": k['DefencePerScale'],
					"RangeMin": 1 if k['ContactOffence'] else 2,
					"RangeMax": k['OffenceRadius'],
					"Speed": k['Movability'],
					"Initiative": k['Speed'],
					"MovementKind": 2 if '骑' in k['Name'] else 1,
					# "MovementKind": movement_mapping[k['ID']]
					"TerrainStrength": {
						1: k['PlainRate'],
						2: k['GrasslandRate'],
						3: k['ForrestRate'],
						4: k['MarshRate'],
						5: k['MountainRate'],
						6: k['WaterRate'],
						7: k['RidgeRate'],
						8: k['WastelandRate'],
						9: k['DesertRate'],
						10: k['CliffRate']
					}
				})
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
		
		with open(file_name + '/ArchitectureKinds.json', mode='w', encoding='utf-8') as fout:
			r = []
			for i in common['AllArchitectureKinds']['ArchitectureKinds']:
				k = i['Value']
				r.append({
					"_Id": k['ID'],
					"Image": str(k['ID']) + ".png",
					"Name": k['Name'],
					"Agriculture": k['AgricultureBase'] + k['AgricultureUnit'],
					"Commerce": k['CommerceBase'] + k['CommerceUnit'],
					"Morale": k['MoraleBase'] + k['MoraleUnit'],
					"Endurance": k['EnduranceBase'] + k['EnduranceUnit'],
					"Population": k['PopulationBase'] + k['PopulationBoundary'] * 5,
				})
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
			
		with open(file_name + '/Architectures.json', mode='w', encoding='utf-8') as fout:
			r = []
			states = {x['ID']: x['Name'] for x in obj['States']['GameObjects']}
			for k in obj['Architectures']['GameObjects']:
				position = [int(x) for x in k['ArchitectureAreaString'].split(' ') if x]
				persons = [int(x) for x in k['PersonsString'].split(' ') if x]
				r.append({
					"_Id": k["ID"],
					"Kind": k['KindId'],
					"Name": k['Name'],
					"Title": states[k['StateID']] + ' ' + k['Name'],
					"MapPosition": [position[0], position[1] - 1],
					"PersonList": persons,
					"Population": k['Population'],
					"Fund": k['Fund'],
					"Food": k['Food'],
					"Agriculture": k['Agriculture'],
					"Commerce": k['Commerce'],
					"Morale": k['Morale'],
					"Endurance": k['Endurance'],
					"Troop": 0,
					"TroopMorale": 0,
					"TroopCombativity": 0
				})
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
			
		with open(file_name + '/Sections.json', mode='w', encoding='utf-8') as fout:
			r = []
			for k in obj["Sections"]["GameObjects"]:
				archs = [int(x) for x in k['ArchitecturesString'].split(' ') if x]
				r.append({
				  "_Id": k['ID'],
				  "Name": k['Name'],
				  "ArchitectureList": archs
				})
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
				
		with open(file_name + '/Factions.json', mode='w', encoding='utf-8') as fout:
			r = []
			colors = common['AllColors']
			first = True
			for k in obj["Factions"]["GameObjects"]:
				sects = [int(x) for x in k['SectionsString'].split(' ') if x]
				r.append({
				  "_Id": k['ID'],
				  "Name": k['Name'],
				  "Color": [colors[k['ColorIndex']]['R'], colors[k['ColorIndex']]['G'], colors[k['ColorIndex']]['B']],
				  "SectionList": sects,
				  "PlayerControlled": first
				})
				first = False
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
				
		with open(file_name + '/Persons.json', mode='w', encoding='utf-8') as fout:
			r = []
			for k in obj['Persons']['GameObjects']:
				r.append({
					"_Id": k['ID'],
					"Surname": k['SurName'],
					"GivenName": k['GivenName'],
					"CourtesyName": k['CalledName'],
					"Command": k['BaseCommand'],
					"Strength": k['BaseStrength'],
					"Intelligence": k['BaseIntelligence'],
					"Politics": k['BasePolitics'],
					"Glamour": k['BaseGlamour'],
					"Task": 0
				})
			fout.write(json.dumps(r, indent=2, ensure_ascii=False, sort_keys=True))
				
		with open(file_name + '/Scenario.json', mode='w', encoding='utf-8') as fout:
			fout.write(json.dumps({
			  "CurrentFactionId": 1,
			  "GameData":
			  {
				"Year": obj['Date']['Year'],
				"Month": obj['Date']['Month'],
				"Day": obj['Date']['Day']
			  }
			}, indent=2, ensure_ascii=False, sort_keys=True))
