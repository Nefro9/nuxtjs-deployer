# Config
NUXT_FILE='nuxt.config.js'

# Color codes
RED='\e[91m'
BLUE='\033[1;36m'
NC='\033[0m' # No color

# Build dirs
CURRENT_DIR=$(grep -Po "buildDir: \'\K[A-Za-z0-9/./-]*" ${NUXT_FILE})
NEW_DIR="${CURRENT_DIR}_tmp"

# Rename the build directory
echo "${BLUE}Builder:${NC} [${NUXT_FILE}] Change buildDir from ${RED}${CURRENT_DIR}${NC} to ${RED}${NEW_DIR}${NC}"
sed -i "s/buildDir: '${CURRENT_DIR}'/buildDir: '${NEW_DIR}'/" ${NUXT_FILE}


echo "${BLUE}Builder:${NC} Start build"
npm run build

# Revert the rename
echo "${BLUE}Builder:${NC} [${NUXT_FILE}] Revert buildDir from ${RED}${NEW_DIR}${NC} to ${RED}${CURRENT_DIR}${NC}"
sed -i "s/buildDir: '${NEW_DIR}'/buildDir: '${CURRENT_DIR}'/" ${NUXT_FILE}

# Replace the existing directory with the new build
echo "${BLUE}Builder:${NC} Replace folder ${RED}${CURRENT_DIR}${NC} with ${RED}${NEW_DIR}${NC}"
rm -rf "${CURRENT_DIR}" && mv "${NEW_DIR}" "${CURRENT_DIR}"

# Start new servers
echo "${BLUE}Builder:${NC} Update APP with new build"
pm2 delete all ; pm2 start

