import React from "react";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import clsx from "clsx";
import styles from "./index.module.css";
import "./home.css";

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header
      className={clsx("hero", styles.heroBanner)}
      style={{
        backgroundColor: "#1c1c1f",
        padding: "4rem 0",
        textAlign: "left",
        flexDirection: "row",
        justifyContent: "space-between"
      }}
    >
      <div className="container" style={{ maxWidth: "800px" }}>
        <h1
          style={{
            fontSize: "3.5rem",
            fontWeight: "800",
            marginBottom: "0.75rem",
            color: "#c8c8c8",
          }}
        >
          <span style={{ color: "#67AE6E", fontWeight: 700 }}>Axis</span>
          <br />
          ECS Input Library
        </h1>
        <p
          style={{
            fontSize: "1.25rem",
            color: "#a2a2a5",
            fontWeight: 500,
            marginBottom: "2.5rem",
          }}
        >
          Agnostic, simple and versatile input library for ECS
        </p>
        <div style={{ display: "flex", gap: "1rem", flexWrap: "wrap" }}>
          <Link
            className="button"
            to="/docs/intro"
            style={{
              borderRadius: "9999px",
              fontSize: "1rem",
              padding: "0.75rem 1.75rem",
              backgroundColor: "#67AE6E", // "#3b82f6",
              color: "#fff",
              fontWeight: "600",
            }}
          >
            Learn
          </Link>
          <Link
            className="button"
            to="/api/Axis"
            style={{
              borderRadius: "9999px",
              fontSize: "1rem",
              padding: "0.75rem 1.75rem",
              backgroundColor: "#2c2c2f",
              color: "#fff",
              fontWeight: "600",
            }}
          >
            API Reference
          </Link>
          <a
            className="button"
            href="https://github.com/NeonD00m/Axis"
            style={{
              borderRadius: "9999px",
              fontSize: "1rem",
              padding: "0.75rem 1.75rem",
              backgroundColor: "#2c2c2f",
              color: "#fff",
              fontWeight: "600",
            }}
          >
            GitHub
          </a>
        </div>
      </div>
      <img
        src="https://media.discordapp.net/attachments/997871955199926386/1361109643614486548/AxisLogo.png?ex=67fd8fa3&is=67fc3e23&hm=99479df432b0601c4c52787512719b227a74fe7cf1fe896b20268ea76ea07a61&=&format=webp&quality=lossless&width=911&height=911"
        className="bigLogo"
        alt="Axis"
      />
    </header>
  );
}

export default function Home() {
  const { siteConfig, tagline } = useDocusaurusContext();
  return (
    <Layout title={siteConfig.title} description={tagline}>
      <HomepageHeader />
    </Layout>
  );
}