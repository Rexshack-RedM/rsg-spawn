let currentIndex = 0;
const app = document.getElementById('app');
const bgLayer = document.getElementById('bg-layer');
const cityNameEl = document.getElementById('city-name');
const cityDescEl = document.getElementById('city-desc');

// --- UI LOGIC ---

function updateUI() {
    const loc = locations[currentIndex];
    
    // Text fade out
    cityNameEl.style.opacity = 0;
    cityNameEl.style.transform = "scale(0.95)";
    
    setTimeout(() => {
        cityNameEl.innerText = loc.label;
        cityDescEl.innerText = loc.desc || "";
        
        // Update background image
        bgLayer.style.backgroundImage = `url('${loc.image}')`;
        
        // Text fade in
        cityNameEl.style.opacity = 1;
        cityNameEl.style.transform = "scale(1)";
    }, 200);
}

function nextLocation() {
    currentIndex++;
    if (currentIndex >= locations.length) {
        currentIndex = 0;
    }
    updateUI();
}

function prevLocation() {
    currentIndex--;
    if (currentIndex < 0) {
        currentIndex = locations.length - 1;
    }
    updateUI();
}

function selectLocation() {
    const selected = locations[currentIndex];
    
    if (window.GetParentResourceName) {
        fetch(`https://${GetParentResourceName()}/spawnSelected`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({
                locationId: selected.id,
                locationLabel: selected.label
            })
        });
    } else {
        // Visual feedback if outside the game environment
        const btn = document.querySelector('.spawn-btn');
        btn.innerText = "TRAVELING...";
        btn.style.background = "#580000";
    }
}

function openNui(data) {
    if (data && data.locations) {
        locations = data.locations;
    }
    currentIndex = 0;
    updateUI();
    app.style.display = 'flex';
}

function closeNui() {
    app.style.display = 'none';
}

// --- EVENT LISTENERS ---

window.addEventListener('message', function(event) {
    const item = event.data;
    if (item.type === "OPEN_SPAWN_MENU") {
        openNui(item);
    } else if (item.type === "CLOSE_MENU") {
        closeNui();
    }
});

// Keyboard Navigation
document.addEventListener('keydown', (e) => {
    if (app.style.display === 'none') return;
    
    if (e.key === 'ArrowRight' || e.key === 'd') nextLocation();
    if (e.key === 'ArrowLeft' || e.key === 'a') prevLocation();
    if (e.key === 'Enter') selectLocation();
});