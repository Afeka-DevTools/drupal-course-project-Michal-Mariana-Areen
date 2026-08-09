# Drupal Docker Environment with Automated Backup & Restore

פרויקט זה מציע סביבת Drupal מלאה המורצת על גבי קונטיינרים של Docker ומחוברת לבסיס נתונים MySQL. הפרויקט כולל מנגנון אוטומטי מלא להקמה, גיבוי, שחזור וניקוי של הסביבה באמצעות סקריפטים של Bash.

---

## 👥 חברי הצוות (Team Members)
* **מיכל** (Michal)
* **מריאנה** (Mariana)
* **ארין** (Areen)

---

## 📁 מבנה הפרויקט (Project Structure)

```text
drupal-project/
├── setup.sh               # סקריפט להקמת הרשת והקונטיינרים
├── backup.sh              # סקריפט לביצוע גיבוי מלא לבסיס הנתונים
├── restore.sh             # סקריפט לשחזור בסיס הנתונים מתוך הגיבוי
├── cleanup.sh             # סקריפט להסרת הקונטיינרים, הרשת והאימאג'ים
├── my-drupal.backup.sql   # קובץ הגיבוי של בסיס הנתונים (Dump)
└── README.md              # תיעוד ומדריך למשתמש
```

---

## 🛠️ דרישות מוקדמות (Prerequisites)

* **Docker Desktop** מותקן ופעיל.
* **PowerShell** / **Bash Terminal**.

---

## 📖 מדריך למשתמש (User Guide)

### 1. הקמת הסביבה (Setup)
כדי להקים את הרשת והקונטיינרים של Drupal ו-MySQL, הריצי בטרמינל:
```bash
bash setup.sh
```
לאחר ההרצה, האתר יהיה זמין בדפדפן בכתובת:
`http://localhost:8080`

### 2. גיבוי בסיס הנתונים (Backup)
כדי לבצע גיבוי מלא של בסיס הנתונים לקובץ `my-drupal.backup.sql`:
```bash
bash backup.sh
```

### 3. שחזור בסיס הנתונים (Restore)
כדי לשחזר את הנתונים מתוך קובץ הגיבוי:
```bash
bash restore.sh
```

### 4. ניקוי הסביבה (Cleanup)
כדי לעצור ולמחוק את הקונטיינרים, הרשת והאימאג'ים:
```bash
bash cleanup.sh
```

---

## ⚙️ פרטי התקשרות ורכיבים (Configuration Details)

* **Docker Network:** `drupal-net`
* **Drupal Container:** `my-drupal` (פורט: `8080:80`)
* **MySQL Container:** `drupal-db` (פורט: `3306:3306`)
* **Database Name:** `drupaldb`
* **Database User:** `drupaluser`
