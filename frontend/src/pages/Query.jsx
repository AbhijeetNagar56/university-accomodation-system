import React, { useState, useRef } from 'react';

const Query = () => {
  const [query, setQuery] = useState('');
  const [selectedTable, setSelectedTable] = useState('Students');
  const [output, setOutput] = useState('Output will appear here...');
  const fileInputRef = useRef(null);

  // Styling maps directly from your original CSS embedded styles
  const styles = {
    container: {
      maxWidth: '800px',
      margin: 'auto',
      fontFamily: '"Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
      color: '#e2e8f0',
      backgroundColor: '#0f1117',
      padding: '40px',
      borderRadius: '8px',
    },
    heading: {
      fontSize: '1.5rem',
      fontWeight: '600',
      marginBottom: '10px',
    },
    textarea: {
      width: '100%',
      padding: '10px',
      margin: '10px 0',
      background: '#1e2130',
      color: 'white',
      border: 'none',
      minHeight: '100px',
      fontFamily: 'monospace',
      boxSizing: 'border-box',
    },
    select: {
      width: '100%',
      padding: '10px',
      margin: '10px 0',
      background: '#1e2130',
      color: 'white',
      border: 'none',
      boxSizing: 'border-box',
    },
    inputFiles: {
      width: '100%',
      padding: '10px',
      margin: '10px 0',
      background: '#1e2130',
      color: 'white',
      border: 'none',
      boxSizing: 'border-box',
    },
    button: {
      padding: '10px 20px',
      background: '#6366f1',
      color: 'white',
      border: 'none',
      cursor: 'pointer',
      marginRight: '10px',
      fontWeight: '500',
    },
    hr: {
      border: '0',
      height: '1px',
      background: '#334155',
      margin: '30px 0',
    },
    output: {
      background: '#1e2130',
      padding: '15px',
      marginTop: '20px',
      whiteSpace: 'pre-wrap',
      minHeight: '100px',
      fontFamily: 'monospace',
      borderLeft: '4px solid #6366f1',
    }
  };

  // Helper handling 401 Session expirations
  const handleSessionExpired = () => {
    alert("Session expired. Please login again.");
    window.location.reload();
  };

  // ================= QUERY RUNNER =================
  const handleRunQuery = async () => {
    setOutput("Running query...");

    try {
      const res = await fetch("/api/query", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ query })
      });

      if (res.status === 401) {
        handleSessionExpired();
        return;
      }

      const data = await res.json();
      setOutput(JSON.stringify(data, null, 2));

    } catch (err) {
      setOutput("Error running query");
    }
  };

  // ================= CSV UPLOAD =================
  const handleUploadCSV = async () => {
    const file = fileInputRef.current?.files[0];

    if (!file) {
      alert("Select CSV file");
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    setOutput("Uploading CSV...");

    try {
      const res = await fetch(`/api/upload-csv/${selectedTable}`, {
        method: "POST",
        body: formData
      });

      if (res.status === 401) {
        handleSessionExpired();
        return;
      }

      const data = await res.json();
      setOutput(JSON.stringify(data, null, 2));

    } catch (err) {
      setOutput("Upload failed");
    }
  };

  return (
    <div style={styles.container}>
      
      {/* SQL QUERY RUNNER */}
      <h2 style={styles.heading}>SQL Query Runner</h2>
      <textarea 
        style={styles.textarea}
        placeholder="SELECT * FROM Students"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      <button style={styles.button} onClick={handleRunQuery}>Execute</button>

      <hr style={styles.hr} />

      {/* CSV UPLOAD */}
      <h2 style={styles.heading}>CSV Upload</h2>
      <select 
        style={styles.select} 
        value={selectedTable}
        onChange={(e) => setSelectedTable(e.target.value)}
      >
        <option value="Students">Students</option>
        <option value="Advisers">Advisers</option>
        <option value="Courses">Courses</option>
        <option value="Residence_Staff">Residence_Staff</option>
        <option value="Halls">Halls</option>
        <option value="Hall_Rooms">Hall_Rooms</option>
        <option value="Apartments">Apartments</option>
        <option value="Apartment_Rooms">Apartment_Rooms</option>
        <option value="Places">Places</option>
        <option value="Leases">Leases</option>
        <option value="Invoices">Invoices</option>
        <option value="Apartment_Inspections">Apartment_Inspections</option>
        <option value="Next_of_Kin">Next_of_Kin</option>
      </select>

      <input 
        type="file" 
        style={styles.inputFiles}
        accept=".csv" 
        ref={fileInputRef}
      />
      <button style={styles.button} onClick={handleUploadCSV}>Upload CSV</button>

      {/* OUTPUT CONSOLE */}
      <div style={styles.output}>
        {output}
      </div>

    </div>
  );
};

export default Query;