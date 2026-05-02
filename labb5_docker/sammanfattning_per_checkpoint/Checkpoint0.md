**Dockerfile = receptet**
    En textfil med instruktioner för hur en image byggs. Tänk på det som ett recept: "börja med Ubuntu, installera Python, kopiera in min kod, starta appen". Varje rad i en Dockerfile skapar ett "lager" i imagen.

**Image = den färdiga paketeringen**
    Resultatet av att bygga en Dockerfile. En image är en skrivskyddad mall som innehåller allt appen behöver: OS, bibliotek, kod, konfiguration. Den kan lagras lokalt, på Docker Hub, eller i ett privat register som Amazon ECR.
    Tänk på det som en ISO-fil – den gör ingenting i sig, men du kan starta hur många maskiner som helst från den.

**Container = en körande instans av en image**
    När du "kör" en image skapas en container. Containern är en isolerad process som beter sig som om den vore ensam på maskinen. Du kan starta 10 containrar från samma image – alla identiska men oberoende.
    Tänk: image = klass i programmering, container = objekt (instans).

