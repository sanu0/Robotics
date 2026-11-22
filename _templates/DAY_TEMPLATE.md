<!--
DAY LESSON TEMPLATE
Every theory/Week_N/Day_N.md follows this shape, so a lesson generated in Week 20 feels like one from
Week 1. Generate a lesson only when the learner reaches that day (see README "How the Daily Notes Work").

Inputs when generating:
  1. The day's checklist in <phase>/README.md (the plan; cover every item, add nothing that is not needed)
  2. The previous lesson, especially its "Next:" line and "What I still do not understand"
  3. The learner's journal entries from the last few days, if any
  4. The Catch-up Ledger in the main README (skipped prerequisites change how you explain things)

Outputs:
  - <phase>/theory/Week_N/Day_N.md                 (this template, filled in)
  - <phase>/codes/Week_N/Day_N/                     (demos, deliberate-error files, starter code,
                                                     check_dayN.sh whose exit code = number of failures)

House style:
  - Plain, friendly sentences. Explain every new term the first time it appears, in a "🆕 New" box.
  - Predict-then-run: show the command, ask for a prediction, then show the real output.
  - Real output only: run the code and paste what it printed. Never invent output.
  - Deliberate errors: let the learner see the real compiler/runtime error, read it, then fix it.
  - Tie every idea to a real robot ("on Rover-1 this is why the lidar data arrives late").
  - Mark tracks: 🐍 Python, ⚙️ C++, 🧮 math/theory, 🔧 hardware, ☁️ cloud GPU, 🌶️ optional stretch.
  - 2 to 2.5 hours total, including running everything.
-->

# P0X·WN·DN — <Title>

> **What you need to know already:** <prerequisites, linked to earlier lessons; note any Catch-up Ledger gaps>
>
> **Time:** about <N> minutes, including running every example.
>
> **Tracks today:** <🐍 / ⚙️ / 🧮 / 🔧 — and which parts are optional>

<Two or three short paragraphs: the problem today solves on a real robot, and what will be different about
you by the end of the session.>

As always, **predict each example's output before you run it.**

| Part | What you will learn | Time |
|---|---|---|
| Before you start | Sync and build today's code | 5 min |
| 1 | <...> | <...> |
| 2 | <...> | <...> |
| 3 | <...> | <...> |
| Your turn | <...> | <...> |

---

## Before You Start (5 minutes)

```bash
rpull                                              # repo -> WSL
rb <phase>/codes/Week_N/Day_N                      # build today's packages and source them
```

<What is in today's code folder, one line per file.>

---

## Part 1 — <Title> (<N> minutes)

<Explanation.>

> **🆕 New — <term>**
>
> <Definition in plain words, with the smallest possible example.>

```bash
<command>
```

> **▶ Try it.** <What to predict, then what to run.>

```text
<real output>
```

<What the output means, and the one thing to notice.>

---

## Part 2 — <Title> (<N> minutes)

<... same pattern; include at least one deliberate error with its real message ...>

---

## Your Turn (<N> minutes)

<A small task written from scratch that uses today's ideas. State the expected behaviour clearly.>

<details>
<summary>One possible solution, and its output</summary>

```python
<solution>
```

</details>

```bash
rpush
bash ~/Robotics/<phase>/codes/Week_N/Day_N/check_dayN.sh
```

---

## Checking Yourself

1. <question>
2. <question>
3. <question>

<details>
<summary>Answers</summary>

1. <answer>
2. <answer>
3. <answer>

</details>

---

## Common Confusions

**"<misconception>"** <Correction, in two or three sentences.>

---

## My Notes

### The errors I caused on purpose

| Error | What the message told me | How I fixed it |
|---|---|---|
| | | |

### In my own words

<Two or three prompts for the learner to answer.>

### Numbers I measured

### What I still do not understand

---

## Done When

<Four to eight statements of the form "You can ..." — concrete, checkable.>

---

## Further Reading

<One to three items, with why each is worth the time.>

## If You Have More Time (optional)

<One or two 🌶️ extensions.>

---

## 📖 Revision — Read This First When You Come Back

### The day as a story

<Three or four paragraphs retelling the day without code.>

### If you remember only five things

1. <...>
2. <...>
3. <...>
4. <...>
5. <...>

### Quick recall

1. <question>
2. <question>

<details>
<summary>Answers</summary>

1. <answer>
2. <answer>

</details>

### The code, in order

```bash
<every command from today, in order, with a one-line comment each>
```

---

**Next:** P0X·WN·D(N+1) — <title and one sentence on what comes next.>
