const fs = require('fs');
const path = require('path');

const filePath = path.join('lib', 'presentation', 'home', 'view', 'accidentdetails.dart');

let content = fs.readFileSync(filePath, 'utf8');

const target = `                // --- FIXED ROW ALIGNMENT ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Top align columns
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weather Conditions",
                            style: _labelStyle(),
                            maxLines: 2, // Ensure same space for both
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(controller.weatherCondition, [
                            "Clear", "Rainy", "Foggy", "Snowy", "Windy"
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Road Conditions",
                            style: _labelStyle(),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          _buildDropdown(controller.roadCondition, [
                            "Dry", "Wet", "Icy", "Loose Gravel", "Uneven"
                          ]),
                        ],
                      ),
                    ),

                  ],
                )`;

const replacement = `                // --- PERFECT HORIZONTAL ALIGNMENT ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Weather Conditions",
                        style: _labelStyle(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Road Conditions",
                        style: _labelStyle(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(controller.weatherCondition, [
                        "Clear", "Rainy", "Foggy", "Snowy", "Windy"
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(controller.roadCondition, [
                        "Dry", "Wet", "Icy", "Loose Gravel", "Uneven"
                      ]),
                    ),
                  ],
                )`;

// Normalize line endings to \n for replacement
const normalizedContent = content.replace(/\r\n/g, '\n');
const normalizedTarget = target.replace(/\r\n/g, '\n');
const normalizedReplacement = replacement.replace(/\r\n/g, '\n');

if (normalizedContent.includes(normalizedTarget)) {
    const newContent = normalizedContent.replace(normalizedTarget, normalizedReplacement);
    // Write back with Windows line endings (\r\n)
    fs.writeFileSync(filePath, newContent.replace(/\n/g, '\r\n'), 'utf8');
    console.log('SUCCESS: Aligned weather and road conditions dropdowns perfectly!');
} else {
    console.log('ERROR: Target content not found in accidentdetails.dart!');
}
