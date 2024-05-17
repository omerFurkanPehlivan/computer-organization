import json

# Load the JSON file
with open('strmod/diagrams/adder.json', 'r') as f:
    data = json.load(f)

# Traverse the data structure and anonymize the net names
for module in data['modules'].values():
    for net in module['netnames'].keys():
        module['netnames']['anon_' + str(hash(net))] = module['netnames'].pop(net)

# Write the modified data back to the JSON file
with open('strmod/diagrams/adder_anon.json', 'w') as f:
    json.dump(data, f, indent=2)