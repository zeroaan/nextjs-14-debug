"use client";
import { useRouter, useSearchParams } from "next/navigation";

export default function Content() {
  const router = useRouter();
  const s = useSearchParams();
  const id = s.get("id");
  function navigate() {
    router.push("/");
  }

  function changeState() {
    const id = s.get("id");
    if (id === "1" || id === 1) {
      router.replace("/content?id=2");
    } else {
      router.replace("/content?id=1");
    }
  }
  return (
    <div style={{ background: id === "1" ? "red" : "blue" }}>
      content
      <button onClick={navigate}> click to navigate</button>
      <button onClick={changeState}> click to change state </button>
      <img src={id === "1" ? "/next.svg" : "vercel.svg"} />
    </div>
  );
}
